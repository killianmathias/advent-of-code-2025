import Foundation
import Combine

// Part 2 ViewModel
class Part2ViewModel: ObservableObject {
    @Published var result: Int = 0
    var devices: [String: Device] = [:]
    
    var memo: [String: Int] = [:]

    // Function that open a file in background and call countPaths after loading file
    func openFile() {
        guard let url = Bundle.main.url(forResource: "input", withExtension: "txt") else {
            print("Erreur chargement fichier")
            return
        }

        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            
            do {
                let content = try String(contentsOf: url, encoding: .utf8)
                let lines = content.components(separatedBy: .newlines)
                
                var tempDevices: [String: Device] = [:]
                
                for line in lines {
                    if line.isEmpty { continue }
                    let subline = line.split(separator: ":")
                    guard subline.count == 2 else { continue }
                    
                    let name = subline[0].trimmingCharacters(in: .whitespaces)
                    
                    let dests = subline[1]
                        .components(separatedBy: .whitespaces)
                        .map { $0.trimmingCharacters(in: .whitespaces) }
                        .filter { !$0.isEmpty }
                    
                    let device = Device(name: name, destinations: dests)
                    tempDevices[name] = device
                }
                self.devices = tempDevices
                
                self.countPaths()
                
            } catch {
                print("Error \(error)")
            }
        }
    }
    
    // Function that count the number of path containing "fft" and "dac" using memoization
    func countPaths() {
        self.memo = [:]
        
        let total = dfs(
            current: "svr",
            target: "out",
            fft: false,
            dac: false
        )
        
        DispatchQueue.main.async {
            self.result = total
        }
    }
    
    // Function that use recursive DFS to search the number of path from current to target containing "fft" and "dac"
    func dfs(current: String, target: String, fft: Bool, dac: Bool) -> Int {
        let newfft = fft || current == "fft"
        let newdac = dac || current == "dac"
        
        let key = "\(current)-\(newfft)-\(newdac)"
        if let cachedValue = memo[key] {
            return cachedValue
        }
        
        if current == target {
            return (newfft && newdac) ? 1 : 0
        }
        
        guard let device = devices[current] else {
            return 0
        }
        
        var totalPaths = 0
        
        for dest in device.destinations {
            totalPaths += dfs(
                current: dest,
                target: target,
                fft: newfft,
                dac: newdac
            )
        }
        
        memo[key] = totalPaths
        return totalPaths
    }
}
