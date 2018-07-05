//
//  Constants.swift
//  SaldoDeHoras
//
//  Created by Iago Mordente Rezende Leão Corrêa on 25/06/18.
//  Copyright © 2018 Iago Mordente Rezende Leão Corrêa. All rights reserved.
//

struct Constants {
    
    static let backButton = "‹Back"
    static let separator: Character = ":"
    static let saturday = "Sábado"
    static let friday = "Sexta"
    static let two = 2
    static let one = 1
    static let zero = 0
    static let emptyString = ""
    
    struct Values {
        static let timeComponentsCount = 2
        static let defaultComponentsCount = 1
        
        struct Round {
            static let button: CGFloat = 50
            static let view: CGFloat = 5
        }
        
        struct ChecksView {
            static let snapThreshold: CGFloat = -20
        }

        struct TableView {
            static let numberOfRowsInSection = 3
        }
        
        struct Constraint {
            static let lowerConstraint: CGFloat = -60
            static let higherConstraint: CGFloat = 20
        }
        
        struct Sizes {
            static let timeFrameWidth: CGFloat = 100
            static let weekFrameWidth: CGFloat = 120
            static let hoursFrameWidth: CGFloat = 50
            static let distanceBetweenLabels: CGFloat = 20
            static let timePickerWidth: CGFloat = 60
            static let optionsFontSize: CGFloat = 16
            static let tableViewHeight: CGFloat = 70
            static let fbLoginButtonCenterY: CGFloat = 50
            static let fbShareButtonCenterY: CGFloat = 80
            static let checkLabelWidth: CGFloat = 100
            static let checksAddDistance: CGFloat = 10
        }
        
        struct AnimationDuration {
            static let short = 0.5
            static let long  = 1.0
        }
        
        struct Time {
            static let minutesUntilNotification = 15
            static let minutesInHour = 60
            static let dayInSeconds = secondsInHour*24
            static let secondsInHour = 3600
        }
    }
    
    struct Messages {
        
        static let okButton = "OK"
        
        struct Facebook {
            static let rickRoll = "https://www.youtube.com/watch?v=dQw4w9WgXcQ"
            static let shareMessage = "Estou usando Saldo de Horas para marcar meu ponto!"
        }
        
        struct LoginAlert {
            static let loginAlertTitle = "Preencha o campo usuário"
            static let loginAlertMessage = "Campo usuário não pode estar vazio."
        }
        
        struct HoursAlert {
            static let invalidHoursTitle = "Horas inválidas"
            static let invalidHoursMessage = "Entre com um valor válido de horas"
            static let invalidHoursBank = "Você está tentando pagar horas além das que você trabalhou."
            static let successTitle = "Horas pagas"
            static let successMessage = "Horas pagas com sucesso."
        }
        
        struct LuchNotification {
            static let title = "Hora de voltar do almoço"
            static let body = ""
            static let notificationTime = 45.0*60.0
        }
        
        struct CheckInNotification {
            static let title = "Está na hora de bater o ponto!"
            static let body = ""
        }
        
        struct NotificationAlertError {
            static let title = "Erro ao agendar notificação"
        }
        
        struct Labels {
            static let timeLabel = "Hora de entrada: "
            static let weekLabel = "Semana até dia: "
            static let hoursLabel = "Duração semanal da jornada: "
        }
    }
    
    struct Identifiers {
        static let navigationController = "NavigationController"
        static let optionsViewController = "OptionsViewController"
        static let hoursViewController = "HoursViewController"
        static let lunchNotification = "lunch"
        static let checkInNotification = "checkIn"
        static let optionsCell = "cell"
        static let timePicker = "time"
        static let dayPicker = "day"
        static let hoursPicker = "hours"
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
        static let pickerComponent = 0
        static let navigationController = 0
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
    
    struct Error {
        static let dateConversionError = "Erro ao converter a data."
        static let notificationBookingError = "Erro ao agendar notificação de entrada"
        static let beyondRange = "Além do range de opções"
    }
    
    struct Options {
        static let days = ["Sexta", "Sábado"]
        static let hours = [20, 30, 40, 44]
        static let optionsCount = 2
    }
    
    struct Locales {
        static let ptBR = "pt_BR"
    }
    
    struct Formats {
        static let timeFormat = "HH:mm"
    }
}

