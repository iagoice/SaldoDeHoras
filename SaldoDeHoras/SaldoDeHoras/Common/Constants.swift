//
//  Constants.swift
//  SaldoDeHoras
//
//  Created by Iago Mordente Rezende Leão Corrêa on 25/06/18.
//  Copyright © 2018 Iago Mordente Rezende Leão Corrêa. All rights reserved.
//

let today = Date()

struct Constants {
    
    static let backButton = "‹Back"
    static let separator: Character = ":"
    
    struct AnimationDuration {
        static let short = 0.5
        static let long  = 1.0
    }
    
    struct ConstraintValues {
        static let lowerConstraint: CGFloat = -60
        static let higherConstraint: CGFloat = 20
    }
    
    struct Indices {
        static let last = 1
        static let secondToLast = 2
        static let picker = 0
        static let dayPicker = 1
        static let section = 0
        static let subviewPosition = 3
        static let separatorHour = 0
        static let separatorMinute = 1
    }
    
    struct DefaultValues {
        static let checkInTime = "08:00"
        static let weekWorkHours: Int16 = 40
        static let workWeek = "Sexta"
        static let workedHours: Int16 = 0
        static let zero: Int16 = 0
    }
    
    struct Entities {
        static let user = "User"
        static let checks = "Check"
        static let options = "Options"
    }
    
    struct Storyboards {
        static let main = "Main"
    }
    
    struct Messages {
        struct LoginAlert {
            static let loginAlertTitle = "Preencha o campo usuário"
            static let loginAlertMessage = "Campo usuário não pode estar vazio."
            static let alertOKButton = "OK"
        }
        struct LuchNotification {
            static let title = "Hora de voltar do almoço"
            static let body = ""
            static let notificationTime = 45.0*60.0
        }
        struct NotificationAlertError {
            static let title = "Erro ao agendar notificação"
        }
    }
    
    struct Error {
        static let dateConversionError = "Erro ao converter a data."
    }
    
    struct Options {
        static let days = ["Sexta", "Sábado"]
        static let hours = [20, 30, 40, 44]
    }
    
    struct Identifiers {
        static let navigationController = "NavigationController"
        static let optionsViewController = "OptionsViewController"
        static let hoursViewController = "HoursViewController"
        static let lunchNotification = "lunch"
    }
    
    struct Locales {
        static let ptBR = "pt_BR"
    }
}

