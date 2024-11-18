//
//  EmpDetailsViewController.swift
//  iOSAppplication
//
//  Created by Aress109 on 11/1/23.
//

import UIKit
import Network

class EmpDetailsViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var employeeDetailTable: UITableView!
    
    var employee1 = ["Dipak Patil","21","dip@gmail.net",""]
    
    var employeesData : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        employeeDetailTable.delegate = self
        employeeDetailTable.dataSource = self

//        // Example usage:
//        getIPAddress { ipAddress in
//            if let ipAddress = ipAddress {
//                print("IP Address: \(ipAddress)")
//            } else {
//                print("Unable to determine IP address.")
//            }
//        }
        print("IP address of device is : \(String(describing: UIDevice.current.ipAddress()))")
        print("IPv4 : \(String(describing: NWInterface.InterfaceType.wifi.ipv4))")
        print("IPv6 : \(String(describing: NWInterface.InterfaceType.wifi.ipv6))")

        func ipv6AddressToNumber(ipv6Address: String) -> String? {
            // Split the address and interface
            let components = ipv6Address.components(separatedBy: "%")

            // Extract the address part
            let address = components.first ?? ipv6Address

            // Split the address into its segments
            let segments = address.components(separatedBy: ":")

            // Create an empty array to hold the numeric segments
            var numericSegments = [String]()

            // Convert each segment to its hexadecimal equivalent
            for segment in segments {
                // Check if the segment contains the "::" shorthand for zero segments
                if segment == "" {
                    // Expand shorthand "::" to zeros
                    for _ in 0..<(8 - segments.count + 1) {
                        numericSegments.append("0000")
                    }
                } else {
                    // Pad each segment with leading zeros to ensure it has 4 characters
                    let paddedSegment = String(repeating: "0", count: 4 - segment.count) + segment
                    numericSegments.append(paddedSegment)
                }
            }

            // Join the numeric segments and return the result
            return numericSegments.joined(separator: ":")
        }
        // Example usage:
        if let numericAddress = ipv6AddressToNumber(ipv6Address: NWInterface.InterfaceType.wifi.ipv6 ?? "") {
            print("Numeric Address: \(numericAddress)")
        } else {
            print("Invalid IPv6 address format.")
        }
        print("Get IP adress : \(String(describing: UIDevice.current.getIPAdress()))")
        print("cellular IP address is : \(UIDevice.current.getIPAddress())")

        // for wifi
          let wifi = UIDevice.current.ipv4(for: .wifi)
          let wifi6 = UIDevice.current.ipv6(for: .wifi)

        // for cellular
        let cellular = UIDevice.current.ipv4(for: .wiredcellular)
          let cellular6 = UIDevice.current.ipv6(for: .cellular)
        print("Wifi address is  : \(String(describing: getWiFiAddress()))")
    }
    
    // Data Source Required method
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employee1.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EMPD", for: indexPath)
        cell.textLabel?.text = employee1[indexPath.row]
        return cell
    }


    func getWiFiAddress() -> String? {
        var address : String?

        // Get list of all interfaces on the local machine:
        var ifaddr : UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return nil }
        guard let firstAddr = ifaddr else { return nil }

        // For each interface ...
        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let interface = ifptr.pointee

            // Check for IPv4 or IPv6 interface:
            let addrFamily = interface.ifa_addr.pointee.sa_family
            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {

                // Check interface name:
                let name = String(cString: interface.ifa_name)
                if  name == "en0" {

                    // Convert interface address to a human readable string:
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                                &hostname, socklen_t(hostname.count),
                                nil, socklen_t(0), NI_NUMERICHOST)
                    address = String(cString: hostname)
                } else if name == "en1" {
                    // Convert interface address to a human readable string:
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                                &hostname, socklen_t(hostname.count),
                                nil, socklen_t(1), NI_NUMERICHOST)
                    address = String(cString: hostname)
                }
            }
        }
        freeifaddrs(ifaddr)

        return address
    }

}


// estension to get the ipAddress
extension UIDevice {

    private struct InterfaceNames {
        static let wifi = ["en0"]
        static let wired = ["en2", "en3", "en4"]
        static let cellular = ["pdp_ip0","pdp_ip1","pdp_ip2","pdp_ip3"]
        static let supported = wifi + wired + cellular
    }

    func ipAddress() -> String? {
        var ipAddress: String?
        var ifaddr: UnsafeMutablePointer<ifaddrs>?

        if getifaddrs(&ifaddr) == 0 {
            var pointer = ifaddr

            while pointer != nil {
                defer { pointer = pointer?.pointee.ifa_next }

                guard
                    let interface = pointer?.pointee,
                    interface.ifa_addr.pointee.sa_family == UInt8(AF_INET) || interface.ifa_addr.pointee.sa_family == UInt8(AF_INET6),
                    let interfaceName = interface.ifa_name,
                    let interfaceNameFormatted = String(cString: interfaceName, encoding: .utf8),
                    InterfaceNames.supported.contains(interfaceNameFormatted)
                else { continue }

                var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))

                getnameinfo(interface.ifa_addr,
                            socklen_t(interface.ifa_addr.pointee.sa_len),
                            &hostname,
                            socklen_t(hostname.count),
                            nil,
                            socklen_t(0),
                            NI_NUMERICHOST)

                guard
                    let formattedIpAddress = String(cString: hostname, encoding: .utf8),
                    !formattedIpAddress.isEmpty
                else { continue }

                ipAddress = formattedIpAddress
                break
            }

            freeifaddrs(ifaddr)
        }

        return ipAddress
    }
}

extension NWInterface.InterfaceType {
    var names : [String]? {
        switch self {
        case .wifi: return ["en0"]
        case .wiredEthernet: return ["en2", "en3", "en4"]
        case .cellular: return ["pdp_ip0","pdp_ip1","pdp_ip2","pdp_ip3"]
        default: return nil
        }
    }

    func address(family: Int32) -> String?
    {
        guard let names = names else { return nil }
        var address : String?
        for name in names {
            guard let nameAddress = self.address(family: family, name: name) else { continue }
            address = nameAddress
            break
        }
        return address
    }

    func address(family: Int32, name: String) -> String? {
        var address: String?

        // Get list of all interfaces on the local machine:
        var ifaddr: UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0, let firstAddr = ifaddr else { return nil }

        // For each interface ...
        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let interface = ifptr.pointee

            let addrFamily = interface.ifa_addr.pointee.sa_family
            if addrFamily == UInt8(family)
            {
                // Check interface name:
                if name == String(cString: interface.ifa_name) {
                    // Convert interface address to a human readable string:
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                                &hostname, socklen_t(hostname.count),
                                nil, socklen_t(0), NI_NUMERICHOST)
                    address = String(cString: hostname)
                }
            }
        }
        freeifaddrs(ifaddr)

        return address
    }

    var ipv4 : String? { self.address(family: AF_INET) }
    var ipv6 : String? { self.address(family: AF_INET6) }
}

extension UIDevice {
    private struct Interfaces {
        // INTERFACCIE SUPPORT
        static let wifi = ["en0"]
        static let cellular = ["pdp_ip0","pdp_ip1","pdp_ip2","pdp_ip3"]
        static let supported = wifi + cellular
    }
    func getIPAdress() -> (String?,String?)? {
        var ip4Adress: String?
        var ip6Adress: String?
        var hasAdress: UnsafeMutablePointer<ifaddrs>?


        if getifaddrs(&hasAdress) == 0 {
            var pointer = hasAdress

            while pointer != nil {
                defer { pointer = pointer?.pointee.ifa_next}

                guard let interface = pointer?.pointee else {continue}

                // SEARCH FOR IPV4 OR IPV6 IN THE INTERFACE OF THE NODE
                if  interface.ifa_addr.pointee.sa_family == UInt8(AF_INET) {
                    guard let ip4 = processInterface(interface: interface) else {
                        continue
                    }
                    ip4Adress = ip4
                }

                if interface.ifa_addr.pointee.sa_family == UInt8(AF_INET6) {
                    guard let ip6 = processInterface(interface: interface) else {
                        continue
                    }
                    ip6Adress = ip6
                }
            }
            freeifaddrs(hasAdress)
        }
        return (ip4Adress, ip6Adress)
    }
    func processInterface(interface: ifaddrs) -> String? {

        var ipAdress: String = ""
        guard
            let interfaceName = interface.ifa_name else {return nil}
                           guard
                               let interfaceNameFormatted = String(cString: interfaceName, encoding: .utf8) else {return nil}
        guard Interfaces.supported.contains(interfaceNameFormatted) else {return nil}

                           var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))

                           print(interfaceNameFormatted)

                           // CONVERT THE SOCKET ADRESS TO A CORRESPONDING HOST AND SERVICE
                           getnameinfo(interface.ifa_addr,
                                       socklen_t(interface.ifa_addr.pointee.sa_len),
                                       &hostname, socklen_t(hostname.count),
                                       nil,
                                       socklen_t(0),
                                       NI_NUMERICHOST)

                           guard let formattedIpAdress = String(cString: hostname, encoding: .utf8) else {return nil}
                           if !formattedIpAdress.isEmpty {
                               ipAdress = formattedIpAdress
                           }
        return ipAdress
    }

    func getIPAddress() -> String {
        var address: String?
        var ifaddr: UnsafeMutablePointer<ifaddrs>? = nil
        if getifaddrs(&ifaddr) == 0 {
            var ptr = ifaddr
            while ptr != nil {
                defer { ptr = ptr?.pointee.ifa_next }

                guard let interface = ptr?.pointee else { return "" }
                let addrFamily = interface.ifa_addr.pointee.sa_family
                if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {

                    // wifi = ["en0"]
                    // wired = ["en2", "en3", "en4"]
                    // cellular = ["pdp_ip0","pdp_ip1","pdp_ip2","pdp_ip3"]

                    let name: String = String(cString: (interface.ifa_name))
                    if  name == "en0" || name == "en2" || name == "en3" || name == "en4" || name == "pdp_ip0" || name == "pdp_ip1" || name == "pdp_ip2" || name == "pdp_ip3" {
                        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                        getnameinfo(interface.ifa_addr, socklen_t((interface.ifa_addr.pointee.sa_len)), &hostname, socklen_t(hostname.count), nil, socklen_t(0), NI_NUMERICHOST)
                        address = String(cString: hostname)
                    }
                }
            }
            freeifaddrs(ifaddr)
        }
        return address ?? ""
    }

    
}

enum Network: String {
    case wifi = "en0"
    case cellular = "pdp_ip0"
    case wiredcellular = "en2"
//    case en1 = "en1"
//    case lo = "lo0"
}

// get ipv4 or ipv6 address
extension UIDevice {

    func address(family: Int32, for network: Network) -> String? {
        var address: String?

        // Get list of all interfaces on the local machine:
        var ifaddr: UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0, let firstAddr = ifaddr else { return nil }

        // For each interface ...
        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let interface = ifptr.pointee

            let addrFamily = interface.ifa_addr.pointee.sa_family
            if addrFamily == UInt8(family) {
                // Check interface name:
                let name = String(cString: interface.ifa_name)
                if name == network.rawValue {
                    // Convert interface address to a human readable string:
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                                &hostname, socklen_t(hostname.count),
                                nil, socklen_t(0), NI_NUMERICHOST)
                    address = String(cString: hostname)
                }
            }
        }
        freeifaddrs(ifaddr)

        return address
    }

    func ipv4(for network: Network) -> String? {
        self.address(family: AF_INET, for: network)
    }

    func ipv6(for network: Network) -> String? {
        self.address(family: AF_INET6, for: network)
    }

    // get all addresses
    func getIFAddresses() -> [String] {
        var addresses = [String]()

        // Get list of all interfaces on the local machine:
        var ifaddr : UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return [] }
        guard let firstAddr = ifaddr else { return [] }

        // For each interface ...
        for ptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let flags = Int32(ptr.pointee.ifa_flags)
            let addr = ptr.pointee.ifa_addr.pointee

            // Check for running IPv4, IPv6 interfaces. Skip the loopback interface.
            if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
                if addr.sa_family == UInt8(AF_INET) || addr.sa_family == UInt8(AF_INET6) {

                    // Convert interface address to a human readable string:
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    if (getnameinfo(ptr.pointee.ifa_addr, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count),
                                    nil, socklen_t(0), NI_NUMERICHOST) == 0) {
                        let address = String(cString: hostname)
                        addresses.append(address)
                    }
                }
            }
        }

        freeifaddrs(ifaddr)

        return addresses
    }

}
