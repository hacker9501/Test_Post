//
//  TaskManager.swift
//  Test_Post
//
//  Created by Elver Mayta Hernández on 16/06/25.
//

protocol TaskManagerProtocol {
    func add(_ task: Task<Void, Never>)
    func cancelAll()
}

final class TaskManager: TaskManagerProtocol {
    private var tasks: [Task<Void, Never>] = []

    func add(_ task: Task<Void, Never>) {
        tasks.append(task)
    }

    func cancelAll() {
        tasks.forEach { $0.cancel() }
        tasks.removeAll()
    }
}
