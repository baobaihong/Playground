//
//  CoreDataRelation.swift
//  Playground
//
//  Created by Jason on 2024/2/22.
//

import SwiftUI
import CoreData

/* 3 entities: 
 1. BusinessEntity
 2. DepartmentEntity
 3. EmployeeEntity
 */

class CoreDataManager {
    static let instance = CoreDataManager() // <- Singleton instance
    let container: NSPersistentContainer
    let context: NSManagedObjectContext
    
    private init() {
        container = NSPersistentContainer(name: "CoreDataContainer")
        container.loadPersistentStores { description, error in
            if let error = error {
                print("error loading core data: \(error)")
            }
        }
        context = container.viewContext
    }
    
    func save() {
        do {
            try context.save()
            print("data saved successfully!")
        } catch {
            print("error saving core data: \(error.localizedDescription)")
        }
    }
}

@Observable
class CoreDataRelationViewModel {
    let manager = CoreDataManager.instance
    var businesses: [BusinessEntity] = []
    var departments: [DepartmentEntity] = []
    var employees: [EmployeeEntity] = []
    
    init() {
        getBusiness()
        getDepartments()
        getEmployees()
    }
    
    func getBusiness() {
        let request = NSFetchRequest<BusinessEntity>(entityName: "BusinessEntity")
        
        let sort = NSSortDescriptor(keyPath: \BusinessEntity.name, ascending: true)
        request.sortDescriptors = [sort]
        
        // let filter = NSPredicate(format: "name == %@", "Apple") // Predicate = filter
        // request.predicate = filter
        
        do {
            self.businesses = try manager.context.fetch(request)
        } catch {
            print("error fetch BusinessEntity: \(error.localizedDescription)")
        }
        
    }
    
    func getDepartments() {
        let request = NSFetchRequest<DepartmentEntity>(entityName: "DepartmentEntity")
        
        do {
            self.departments = try manager.context.fetch(request)
        } catch {
            print("error fetch DepartmentEntity: \(error.localizedDescription)")
        }
        
    }
    
    func getEmployees() {
        let request = NSFetchRequest<EmployeeEntity>(entityName: "EmployeeEntity")
        
        do {
            self.employees = try manager.context.fetch(request)
        } catch {
            print("error fetch EmployeeEntity: \(error.localizedDescription)")
        }
        
    }
    
    func getEmployees(forBusiness business: BusinessEntity) {
        let request = NSFetchRequest<EmployeeEntity>(entityName: "EmployeeEntity")
        let filter = NSPredicate(format: "business == %@", business) // <- This kind of format can only work on 'To one' relation
        request.predicate = filter
        
        do {
            self.employees = try manager.context.fetch(request)
        } catch {
            print("error fetch EmployeeEntity: \(error.localizedDescription)")
        }
        
    }
    
    func addBusiness() {
        let newBusiness = BusinessEntity(context: manager.context)
        newBusiness.name = "Facebook"
        
        // add existing department to the new business
        //newBusiness.departments = [departments[0], departments[1]]
        
        // add existing employees to the new business
        // newBusiness.employees = [employees[2]]
        
        // add new business to existing department
        // newBusiness.addToDepartments(<#T##value: DepartmentEntity##DepartmentEntity#>)
        
        // add new business to existing employee
        // newBusiness.addToEmployees(<#T##value: EmployeeEntity##EmployeeEntity#>)
        
        save()
    }
    
    func addDepartment() {
        let newDepartment = DepartmentEntity(context: manager.context)
        newDepartment.name = "Finance"
        newDepartment.businesses = [businesses[0], businesses[1], businesses[2]]
        newDepartment.addToEmployees(employees[1])
        
//        newDepartment.employees = [employees[2]]
//        newDepartment.addToEmployees(employees[2])
        save()
    }
    
    func addEmployee() {
        let newEmployee = EmployeeEntity(context: manager.context)
        newEmployee.age = 21
        newEmployee.dateJoined = Date()
        newEmployee.name = "John"
        
        newEmployee.business = businesses[2]
        newEmployee.department = departments[1]
        save()
    }
    
    func updateBusiness() {
        let existingBusiness = businesses[1]
        existingBusiness.addToDepartments(departments[0])
        save()
    }
    
    func deleteDepartment() {
        let department = departments[1]
        manager.context.delete(department)
        /*
         Three delete rule (modify on the inspector panel):
         1. Nullify(default): delete department, keep its employee
         2. Cascade: delete the department and its employee
         3. Deny: can't delete the department until it has no employee
         */
        save()
    }
    
    func save() {
        businesses.removeAll()
        departments.removeAll()
        employees.removeAll()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: DispatchWorkItem(block: {
            self.manager.save()
            self.getBusiness()
            self.getDepartments()
            self.getEmployees()
        }))
    }
}

struct CoreDataRelation: View {
    
    @State var vm = CoreDataRelationViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    Button(action: {
                        vm.deleteDepartment()
                    }, label: {
                        Text("Perform Action")
                            .foregroundStyle(.white)
                            .frame(height: 55)
                            .frame(maxWidth: .infinity)
                            .background(Color.blue.clipShape(RoundedRectangle(cornerRadius: 10)))
                    })
                    .padding()
                    
                    ScrollView(.horizontal) {
                        HStack(alignment: .top) {
                            ForEach(vm.businesses) { business in
                                BusinessView(entity: business)
                            }
                        }
                    }
                    .padding()
                    
                    ScrollView(.horizontal) {
                        HStack(alignment: .top) {
                            ForEach(vm.departments) { department in
                                DepartmentView(entity: department)
                            }
                        }
                    }
                    .padding()
                    
                    ScrollView(.horizontal) {
                        HStack(alignment: .top) {
                            ForEach(vm.employees) { employee in
                                EmployeeView(entity: employee)
                            }
                        }
                    }
                    .padding()
                    
                }
                .navigationTitle("Relationships")
            }
        }
    }
}

#Preview {
    CoreDataRelation()
}

struct BusinessView: View {
    let entity: BusinessEntity
    var body: some View {
        VStack(alignment: .leading, spacing: 20.0) {
            Text("Name: \(entity.name ?? "")")
                .bold()
            if let departments = entity.departments?.allObjects as? [DepartmentEntity] {
                Text("Departments:")
                    .bold()
                ForEach(departments) { department in
                    Text(department.name ?? "")
                }
            }
            if let employees = entity.employees?.allObjects as? [EmployeeEntity] {
                Text("Employees:")
                    .bold()
                ForEach(employees) { employee in
                    Text(employee.name ?? "")
                }
            }
        }
        .padding()
        .frame(maxWidth: 300, alignment: .leading)
        .background(Color.gray.opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(radius: 10)
    }
}

struct DepartmentView: View {
    let entity: DepartmentEntity
    var body: some View {
        VStack(alignment: .leading, spacing: 20.0) {
            Text("Name: \(entity.name ?? "")")
                .bold()
            if let businesses = entity.businesses?.allObjects as? [BusinessEntity] {
                Text("Businesses:")
                    .bold()
                ForEach(businesses) { business in
                    Text(business.name ?? "")
                }
            }
            if let employees = entity.employees?.allObjects as? [EmployeeEntity] {
                Text("Employees:")
                    .bold()
                ForEach(employees) { employee in
                    Text(employee.name ?? "")
                }
            }
        }
        .padding()
        .frame(maxWidth: 300, alignment: .leading)
        .background(Color.green.opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(radius: 10)
    }
}

struct EmployeeView: View {
    let entity: EmployeeEntity
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20.0) {
            Text("Name: \(entity.name ?? "")")
                .bold()
            Text("age: \(entity.age)")
            Text("data joined: \(entity.dateJoined ?? Date())")
            Text("Business:")
                .bold()
            Text(entity.business?.name ?? "")
            Text("Department:")
                .bold()
            Text(entity.department?.name ?? "")
        }
        .padding()
        .frame(maxWidth: 300, alignment: .leading)
        .background(Color.blue.opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(radius: 10)
    }
}

