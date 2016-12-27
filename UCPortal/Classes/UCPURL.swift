//
//  UCPURL.swift
//  Pods
//
//  Created by Nicolás Gebauer on 25-12-16.
//
//

import Foundation

public struct UCPURL {
    
    // MARK: - Cas
    
    public static let domainCas = "sso.uc.cl"
    
    public static let loginCas = "https://\(domainCas)/cas/login"
    public static let logoutCas = "https://\(domainCas)/cas/logout"
    
    // MARK: - Portal
    
    public static let domain = "portal.uc.cl"
    
    public static let portal = "https://\(domain)/web/home-community/inicio"
    
    public static let macRegistryPrepare = "https://\(domain)/c/portal/render_portlet?p_l_id=10229&p_p_id=RegistroMac_WAR_LPT028_RegistroMac_INSTANCE_L0Zr&p_p_lifecycle=0&p_p_state=normal&p_p_mode=view&p_p_col_id=column-3&p_p_col_pos=1&p_p_col_count=2&currentURL=%2Fweb%2Fhome-community%2Finicio"
    
    public static let macRegistryGet = "https://\(domain)/LPT028_RegistroMac/GetListaMac_controller"
    public static let macAdd = "https://\(domain)/LPT028_RegistroMac/AgregarRegistroMac_controller"
    public static let macDelete = "https://\(domain)/LPT028_RegistroMac/EliminarRegistroMac_controller"
}
