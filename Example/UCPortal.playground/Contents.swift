import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true
import Kanna
import Alamofire
import UCPortal


var tries = 0
var count = 0
func test() {
    print("Go test")
    UCPNetwork(url: UCPURL.macRegistryPrepare, method: .post) { response in
        
        let html = UCPUtils.string(response) ?? ""
        guard html.contains("Registro WIFI") else { print(1); return test() }
        print(html)
        
        UCPNetwork(url: UCPURL.macRegistryGet, method: .post) { response in
            
            let html = UCPUtils.string(response) ?? "FUCK"
            print("\nDATA")
            print(html)
        }
    }
}

func test2() {
    Alamofire.request(UCPURL.macRegistryPrepare, method: .post).response { response in
        let ucpResponse = UCPResponse(data: nil, response: response.response, error: nil)
        
        let html = UCPUtils.string(response.data) ?? ""
//        guard html.contains("Registro WIFI") else { print(1); return test2() }
        print(html)
        
        Alamofire.request(UCPURL.macRegistryGet, method: .post).response { response in
            let ucpResponse = UCPResponse(data: nil, response: response.response, error: nil)
            
            let html = UCPUtils.string(response.data) ?? "FUCK"
            guard html != "" && !html.contains("Application Not Authorized to Use CAS") else { return test2() }
            print("\nDATA")
            print(html)
        }
    }
}

func test3() {
    
    UCPNetwork(url: "https://portal.uc.cl/c/portal/render_portlet?p_l_id=10229&p_p_id=RegistroMac_WAR_LPT028_RegistroMac_INSTANCE_L0Zr&p_p_lifecycle=0&p_p_sta", method: .post) { response in
        print(response.response!.allHeaderFields)
        UCPNetwork(url: "https://portal.uc.cl/LPT028_RegistroMac/GetListaMac_controller", method: .post) { response in
            let html = UCPUtils.string(response)
            print(html!)
            print(response.response!.allHeaderFields)
        }
    }
    
}

func test4() {
    UCPNetwork(url: UCPURL.portal) { response in
        print(UCPUtils.string(response)!)
    }
//    UCPNetwork(url: UCPURL.macRegistryPrepare, method: .post) { response in
//        let html = UCPUtils.string(response)!
//        guard html.contains("Registro WIFI") else { return test4() }
//        print(html)
////        UCPNetwork(url: UCPURL.macRegistryGet, method: .post) { response in
////            let html = UCPUtils.string(response) ?? "NONE"
////            guard html != "" else { return test4() }
////            print(html)
////        }
//    }
}

let session = UCPSession(username: "negebauer", password: "TRY AGAIN")
session.login({
//    test()
//    test2()
//    test3()
    test4()
    }, failure: { error in
        print(error!.error)
})
print("Running...")



