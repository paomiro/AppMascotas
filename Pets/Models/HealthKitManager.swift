import Foundation
import HealthKit
import SwiftUI

class HealthKitManager: ObservableObject {
    static let shared = HealthKitManager()
    private let healthStore = HKHealthStore()
    
    @Published var isAuthorized = false
    
    private init() {}
    
    func requestAuthorization() {
        // Define the types of data we want to read and write
        let typesToRead: Set<HKObjectType> = [
            HKObjectType.quantityType(forIdentifier: .stepCount)!,
            HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
            HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!
        ]
        
        let typesToWrite: Set<HKSampleType> = [
            HKObjectType.quantityType(forIdentifier: .stepCount)!,
            HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!
        ]
        
        healthStore.requestAuthorization(toShare: typesToWrite, read: typesToRead) { success, error in
            DispatchQueue.main.async {
                self.isAuthorized = success
                if let error = error {
                    print("HealthKit authorization error: \(error)")
                }
            }
        }
    }
    
    func savePetActivity(petId: UUID, steps: Int, date: Date) {
        guard let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount) else { return }
        
        let stepQuantity = HKQuantity(unit: HKUnit.count(), doubleValue: Double(steps))
        let stepSample = HKQuantitySample(type: stepType, quantity: stepQuantity, start: date, end: date)
        
        healthStore.save(stepSample) { success, error in
            if success {
                print("Pet activity saved to HealthKit")
            } else if let error = error {
                print("Error saving pet activity: \(error)")
            }
        }
    }
    
    func getPetActivity(for date: Date) -> Int {
        guard let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount) else { return 0 }
        
        let predicate = HKQuery.predicateForSamples(withStart: date, end: Calendar.current.date(byAdding: .day, value: 1, to: date), options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: stepType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, error in
            if let error = error {
                print("Error fetching activity: \(error)")
            }
        }
        
        healthStore.execute(query)
        return 0 // This is a simplified implementation
    }
} 