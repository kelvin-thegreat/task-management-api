<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Task;

class TaskController extends Controller
{
    /**
     * Create a new task
     * Rules:
     * - title must be unique per due_date
     * - due_date must be today or future
     * - priority must be valid
     */
    public function store(Request $request)
    {
        // Validate input (INCLUDING status now)
        $validated = $request->validate([
            'title' => 'required|string',
            'due_date' => 'required|date|after_or_equal:today',
            'priority' => 'required|in:low,medium,high',
            'status' => 'required|in:pending,in_progress,done'
        ]);

        // Prevent duplicate (title + due_date)
        if (Task::where('title', $validated['title'])
            ->where('due_date', $validated['due_date'])
            ->exists()) {
            return response()->json([
                'message' => 'Task already exists for this date'
            ], 422);
        }

        // Create task with ALL fields
        $task = Task::create($validated);

        return response()->json($task, 201);
    }

    /**
     * List all tasks
     * - Sort by priority (high → low)
     * - Then by due_date ascending
     * - Optional filter by status
     */
    public function index(Request $request)
    {
        $query = Task::query();

        // Optional filter
        if ($request->has('status')) {
            $query->where('status', $request->status);
        }

        // Sorting logic
        $tasks = $query
            ->orderByRaw("FIELD(priority, 'high', 'medium', 'low')")
            ->orderBy('due_date', 'asc')
            ->get();

        // Handle empty
        if ($tasks->isEmpty()) {
            return response()->json([
                'message' => 'No tasks found'
            ], 404);
        }

        return response()->json($tasks);
    }

    /**
     * Update task status
     * Rules:
     * - Only forward progression allowed
     * - pending → in_progress → done
     */
    public function updateStatus(Request $request, $id)
    {
        $task = Task::findOrFail($id);

        // Validate input
        $validated = $request->validate([
            'status' => 'required|in:pending,in_progress,done'
        ]);

        // Allowed transitions
        $transitions = [
            'pending' => 'in_progress',
            'in_progress' => 'done'
        ];

        // Enforce rule
        if (($transitions[$task->status] ?? null) !== $validated['status']) {
            return response()->json([
                'message' => 'Invalid status transition'
            ], 422);
        }

        // Update status
        $task->update([
            'status' => $validated['status']
        ]);

        return response()->json($task);
    }

    /**
     * Delete task
     * Rule:
     * - Only tasks marked as done can be deleted
     */
    public function destroy($id)
    {
        $task = Task::find($id);

        // Handling task not found
        if (!$task) {
            return response()->json([
                'message' => 'Task not found'
            ], 404);
        }

        // Required condition
        if ($task->status !== 'done') {
            return response()->json([
                'message' => 'Only completed tasks can be deleted'
            ], 403);
        }

        $task->delete();

        return response()->json([
            'message' => 'Task deleted successfully'
        ], 200);
    }

    public function update(Request $request, $id)
    {
        $task = Task::findOrFail($id);

        $validated = $request->validate([
            'title' => 'required|string',
            'due_date' => 'required|date|after_or_equal:today',
            'priority' => 'required|in:low,medium,high',
            'status' => 'required|in:pending,in_progress,done'
        ]);

        $task->update($validated);

        return response()->json($task);
    }

    /**
     * Daily report (BONUS)
     * Returns grouped counts by priority and status
     */
    public function report(Request $request)
    {
        // Validate date input
        $validated = $request->validate([
            'date' => 'required|date'
        ]);

        $tasks = Task::whereDate('due_date', $validated['date'])->get();

        $summary = [];

        foreach (['high', 'medium', 'low'] as $priority) {
            foreach (['pending', 'in_progress', 'done'] as $status) {
                $summary[$priority][$status] = $tasks
                    ->where('priority', $priority)
                    ->where('status', $status)
                    ->count();
            }
        }

        return response()->json([
            'date' => $validated['date'],
            'summary' => $summary
        ]);
    }
}