<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\Task;

class TaskSeeder extends Seeder
{
    /**
     * Seed the tasks table with sample data
     */
    public function run(): void
    {
        // Predefined list of task titles for realistic data
        $titles = [
            'Design API', 'Fix Bug', 'Write Documentation', 'Deploy App',
            'Test Endpoints', 'Optimize Code', 'Refactor Logic', 'Create UI',
            'Debug Errors', 'Write Unit Tests', 'Integrate API', 'Update Database',
            'Code Review', 'Security Check', 'Add Features', 'Performance Test',
            'Setup Hosting', 'Monitor Logs', 'Backup Data', 'Final Submission'
        ];

        // Available priority levels
        $priorities = ['low', 'medium', 'high'];

        // Possible task statuses
        $statuses = ['pending', 'in_progress', 'done'];

        // Loop through titles and create tasks
        foreach ($titles as $index => $title) {

            Task::create([

                // Assign task title
                'title' => $title,

                // Set due date incrementally (1 day apart per task)
                'due_date' => now()->addDays($index + 1)->toDateString(),

                // Assign random priority
                'priority' => $priorities[array_rand($priorities)],

                // Assign random status
                'status' => $statuses[array_rand($statuses)],
            ]);
        }
    }
}