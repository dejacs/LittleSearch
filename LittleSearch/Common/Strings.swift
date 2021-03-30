//
//  Strings.swift
//  LittleSearch
//
//  Created by Jade Silveira on 29/03/21.
//

import Foundation

enum Strings {
    enum Color {
        static let branding = "clr_branding"
        static let highlight = "clr_highlight"
        static let primaryBackground = "clr_primary_background"
        static let primaryText = "clr_primary_text"
        static let secondaryText = "clr_secondary_text"
        static let tertiaryText = "clr_tertiary_text"
        static let transparentBackground = "clr_transparent_background"
        static let linkText = "clr_link_text"
    }
    
    enum Placeholder {
        static let image = "img_placeholder"
        static let search = "Buscar no Mercado Livre"
    }
    
    enum Locale {
        static let brazil = "pt_BR"
    }
    
    enum CommonMessage {
        static let loadError = "Não foi possível carregar os dados"
        static let emptySearchTitle = "Não encontramos anúncios"
        static let emptySearchMessage = "Verifique se a palavra está escrita corretamente."
        static let errorSearchTitle = "Parece que ocorreu algum erro!"
        static let errorSearchMessage = "Tente novamente mais tarde."
        static let errorSearchButton = "Tentar novamente"
        static let welcomeTitle = "Boas vindas!"
        static let welcomeMessage = "Inicie uma busca para encontrar o produto que procura."
    }
}
