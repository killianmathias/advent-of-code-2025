//
//  Part1ViewModel.swift
//  day-11
//
//  Created by Killian Mathias on 30/12/2025.
//
import Foundation
import Combine

// Part 1 ViewModel
class Part1ViewModel: ObservableObject {
    @Published var result: Int = 0
    @Published var devices : [String:Device] = [:]

    
    // Function that open a file
    func openFile() {
        guard let url = Bundle.main.url(forResource: "input", withExtension: "txt") else {
            print("Erreur chargement fichier")
            return
        }

        do {
            let content = try String(contentsOf: url, encoding: .utf8)
            DispatchQueue.main.async {
                let lines = content.components(separatedBy: .newlines)
                    for line in lines {
                        let subline = line.split(separator: ":")
                        guard subline.count == 2 else { continue }
                        let name = String(
                            subline[0].trimmingCharacters(in: .whitespaces)
                        )
                        let dests = subline[1].split(separator: " ").map {
                            String($0).trimmingCharacters(in: .whitespaces)
                        }
                        let device = (Device(name: name, destinations: dests))
                        self.devices[name] = device
                    }
                print(self.devices)
            }
        } catch {
            print("Error \(error)")
        }
    }
    
    // Function that count the number of path by opening the file then using DFS
    func countPaths(){
        self.openFile()
        self.result = dfs(current : "you", target : "out")
    }
    
    // Function that use recursive DFS to search the number of path from current to target
    func dfs(current :String, target : String) -> Int{
        if current == target{
            return 1
        }
        
        guard let device = devices[current] else{
            return 0
        }
        
        var totalPaths = 0
        
        for dest in device.destinations{
            totalPaths += dfs(current: dest, target: target)
        }
        
        return totalPaths
    }
}
