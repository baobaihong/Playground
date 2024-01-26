//
//  CodablePractice.swift
//  Playground
//
//  Created by Jason on 2024/1/25.
//
// Decode&Encode between custom data model and JSON
// Codable = Decodable + Encodable

import SwiftUI

struct CustomerModel: Identifiable, Codable {
    let id: String
    let name: String
    let points: Int
    let isPremium: Bool
    // typical initializer
//    init(id: String, name: String, points: Int, isPremium: Bool) {
//        self.id = id
//        self.name = name
//        self.points = points
//        self.isPremium = isPremium
//    }
    
    // use Codable protocol, you don't need to manually code decoder and encoder, Codable will do it.
    
    // key for encoding and decoding, providing approach for swift to map between data key and model key
//    enum CodingKeys: CodingKey {
//        case id
//        case name
//        case points
//        case isPremium
//    }
//    //decode initializer, create instance from JSON
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self.id = try container.decode(String.self, forKey: .id)
//        self.name = try container.decode(String.self, forKey: .name)
//        self.points = try container.decode(Int.self, forKey: .points)
//        self.isPremium = try container.decode(Bool.self, forKey: .isPremium)
//    }
//    // encode custom data model to JSON
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(self.id, forKey: .id)
//        try container.encode(self.name, forKey: .name)
//        try container.encode(self.points, forKey: .points)
//        try container.encode(self.isPremium, forKey: .isPremium)
//    }
}

@Observable
class CodableViewModel {
    var customer: CustomerModel? = nil
    
    init() {
        getData()
    }
    // get the data and map to CustomerModel
    func getData() {
        guard let data = getJSONData() else { return }
        self.customer = try? JSONDecoder().decode(CustomerModel.self, from: data)
//        do {
//            self.customer = try JSONDecoder().decode(CustomerModel.self, from: data)
//        } catch let error {
//            print("Error decoding. \(error)")
//        }
        // manual decoder
//        if let localData = try? JSONSerialization.jsonObject(with: data),
//           let dictionary = localData as? [String: Any],
//           let id = dictionary["id"] as? String,
//           let name = dictionary["name"] as? String,
//           let points = dictionary["points"] as? Int,
//           let isPremium = dictionary["isPremium"] as? Bool
//        {
//            let newCustomer = CustomerModel(id: id, name: name, points: points, isPremium: isPremium)
//            customer = newCustomer
//        }
        
    }
    // mock the process of fetching JSON data remotely
    func getJSONData() -> Data? {
        let customer = CustomerModel(id: "111", name: "Emily", points: 100, isPremium: false)
        let jsonData = try? JSONEncoder().encode(customer)
        // manual encode data into JSON format
//        let dictionary: [String: Any] = [
//            "id": "12345",
//            "name": "Joe",
//            "points": 5,
//            "isPremium": true
//        ]
//        let jsonData = try? JSONSerialization.data(withJSONObject: dictionary)
        return jsonData
    }
}

struct CodablePractice: View {
    @State var vm = CodableViewModel()
    
    var body: some View {
        VStack {
            if let customer = vm.customer {
                Text(customer.id)
                Text(customer.name)
                Text("\(customer.points)")
                Text(customer.isPremium.description)
            }
        }
    }
}

#Preview {
    CodablePractice()
}
