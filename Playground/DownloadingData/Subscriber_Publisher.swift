//
//  Subscriber&Publisher.swift
//  Playground
//
//  Created by Jason on 2024/1/30.
//

import SwiftUI
import Combine

class SubscriberViewModel: ObservableObject {
    
    @Published var count: Int = 0
    var cancellables = Set<AnyCancellable>()
    
    //a publisher that publish the value that user input
    //a perfect use case for input association, correction
    @Published var textFieldText: String = ""
    @Published var textIsValid: Bool = false
    @Published var showButton: Bool = false
    
    init() {
        setupTimer()
        addTextFieldSubscriber()
        addButtonSubscriber()
    }
    
    // check input text and perform task
    func addTextFieldSubscriber() {
        $textFieldText
        // execute map after user stop typing for 0.5 seconds
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .map { text in
                if text.count > 3 {
                    return true
                }
                return false
            }
        // bad side: assign can not make self weak
//            .assign(to: \.textIsValid, on: self)
            .sink(receiveValue: { [weak self] isValid in
                self?.textIsValid = isValid
            })
            .store(in: &cancellables)
    }
    
    // setup a timer that publishes every few seconds
    func setupTimer() {
        Timer
            .publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.count += 1
                // stop at 10
//                if self.count >= 10 {
//                    for item in self.cancellables {
//                        item.cancel()
//                    }
//                }
            }
            .store(in: &cancellables)
        
    }
    
    // combine two publishers together to collaborate
    func addButtonSubscriber() {
        $textIsValid
            .combineLatest($count)
            .sink { [weak self] isValid, count in
                guard let self = self else {return}
                if isValid && count >= 10 {
                    self.showButton = true
                } else {
                    self.showButton = false
                }
            }
            .store(in: &cancellables)
    }
    
}

struct Subscriber_Publisher: View {
    
    @StateObject var vm = SubscriberViewModel()
    
    var body: some View {
        VStack {
            Text("\(vm.count)")
                .font(.largeTitle)
            
            TextField("type something here...", text: $vm.textFieldText)
                .padding(.leading)
                .frame(height: 55)
                .background(Color(#colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1)))
                .font(.headline)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            //simulation of a real app that give user feedback when typing
                .overlay(alignment: .trailing) {
                    ZStack {
                        Image(systemName: "xmark")
                            .foregroundStyle(.red)
                            .opacity(
                                vm.textFieldText.count < 1 ? 0.0 :
                                vm.textIsValid ? 0.0 : 1.0)
                        Image(systemName: "checkmark")
                            .foregroundStyle(.green)
                            .opacity(vm.textIsValid ? 1.0 : 0.0)
                    }
                    .font(.subheadline)
                    .padding(.trailing)
                }
            
            Button(action: {}, label: {
                Text("Submit".uppercased())
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .opacity(vm.showButton ? 1.0 : 0.5)
            })
        }
        .padding()
    }
}

#Preview {
    Subscriber_Publisher()
}
