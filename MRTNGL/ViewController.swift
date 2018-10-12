//
//  ViewController.swift
//  MRTNGL
//
//  Created by Igor Sergeevich on 11.09.2018.
//  Copyright © 2018 Igor Sergeevich. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    // --- ИНИЦИАЛИЗАЦИЯ ИНТЕРФЕЙСА --- //
    //  Панель вывода (Вложений, Общей прибыли, Чистой прибыли, Итога)
    @IBOutlet weak var TextView1: NSTextField!
    @IBOutlet weak var TextView2: NSTextField!
    @IBOutlet weak var TextView3: NSTextField!
    @IBOutlet weak var TextView4: NSTextField!
    //  Панель вывода (Необходимого депозита, Общей прибыли, Эффективности)
    @IBOutlet weak var TextViewDeposit: NSTextField!
    @IBOutlet weak var TextViewProfit: NSTextField!
    @IBOutlet weak var TextViewEfficiency: NSTextField!
    //  Панель ввода (Начальная ставка, Процент выйгрыша)
    @IBOutlet weak var InitialBet: NSTextField!
    @IBOutlet weak var WinPercentage: NSTextField!
    //  Панель "Выбор стратегии"
    @IBOutlet weak var ChoiceOfStrategy: NSComboBox!
    //  Флаг "Дробные числа"
    @IBOutlet weak var FlagIntOrDouble: NSButton!
    //  Панель "Рассчет вероятности"
    @IBOutlet weak var EditVer: NSTextField!
    @IBOutlet weak var SliderVer: NSSlider!
    @IBOutlet weak var ViewVer1: NSTextField!
    @IBOutlet weak var ViewVer2: NSTextField!
    @IBOutlet weak var ViewVer3: NSTextField!
    @IBOutlet weak var ViewVer4: NSTextField!
    @IBOutlet weak var ViewVer5: NSTextField!
    @IBOutlet weak var ViewVer6: NSTextField!
    @IBOutlet weak var ViewVer7: NSTextField!
    @IBOutlet weak var ViewVer8: NSTextField!
    @IBOutlet weak var ViewVer9: NSTextField!
    @IBOutlet weak var ViewVer10: NSTextField!
    
    // -------------------------------- //

    
    
    
    
    // --- ИНИЦИАЛИЗАЦИЯ ГЛОБАЛЬНЫХ ПЕРЕМЕННЫХ --- //
    let myRounding = 1
    var table = Array(repeating: Array(repeating: 0.0, count: 19), count: 5) // Двумерный массив 5x19 или [0..4][0..18]
    var procent = 0.0, startMoney = 0.0, deposit = 0.0, effectiveness: Double = 0.0
    // ------------------------------------------- //

    
    
    
    
    
    
     // --- ПРОЦЕДУРЫ И ФУНКЦИИ --- //
    var tempItog: Double = 0.0
    var countRepeat: Int = 0
    func CountingTheTable(lines: Int, flag: Int, flagFractionalNumbers: Bool) -> Void
    {
        countRepeat = 0
        repeat
        {
            // 1-ый столбец таблицы
            if lines == 1 { table[1][lines] = startMoney }
            else
            {
                if countRepeat == 0 { table[1][lines] = table[1][lines-1] * 2 }
                switch flagFractionalNumbers
                {
                    case false: if countRepeat != 0 { table[1][lines] = table[1][lines]+1 }
                    case true: if countRepeat != 0 { table[1][lines] = table[1][lines]+0.1 }
                }
            }
            
            // 3-ый столбец таблицы
            table[3][lines] = procent*table[1][lines]/100
            
            // 2-ый столбец таблицы
            table[2][lines] = table[1][lines]+table[3][lines]
            
            // 4-ый столбец таблицы
            if lines == 1 { table[4][lines] = table[3][lines] ; break }
            else
            {
                // Вычисление ИТОГА
                tempItog = 0.0
                for i in 1...lines-1 { tempItog = tempItog+table[1][i] }
                table[4][lines] = table[3][lines]-tempItog
                // Конец Вычисления ИТОГА
                countRepeat = countRepeat + 1
                if ((flag == -4) && (table[4][lines]>0.1)) { break }
                if ((flag == -3) && (table[4][lines]>=table[4][1])) { break }
                if ((flag == -2) && (table[4][lines]>=table[4][lines-1])) { break }
                if ((flag == -1) && (table[4][lines]>table[4][lines-1])) { break }
                if ((flag > 0) && (table[4][lines] > (table[4][lines-1] + Double(flag/10)))) { break }
            }
        } while true
    }
    
    
    
    
    func IntToBool(value: Int8) -> Bool
    {
        var result = false
        if value == 1 { result = true }
        if value == 0 { result = false }
        return result
    }
    
    func SuperRound(value: Double, numberOfDecimalPlaces: Int) -> Double
    // Пример: SuperRound(99,439, 2) = 99,44, SuperRound(99,439, 3) = 99,439
    {
        var specificRate: Double = 1.0
        for _ in 1...numberOfDecimalPlaces
        {
            specificRate = specificRate * 10
        }
        return round(specificRate*value)/specificRate
    }
    

    
    
    
    
    
    
    // --- КНОПКА "Выбор стратегии" --- //
    @IBAction func ChoiseOfStrategy(_ sender: Any)
    {
        // Очистка полей
        for i in 1...4
        {
            for j in 1...18 { table[i][j] = 0.0 }
        }
        TextView1.stringValue = ""
        TextView2.stringValue = ""
        TextView3.stringValue = ""
        TextView4.stringValue = ""
        
        // Инициализация главных переменных
        startMoney = Double(InitialBet.stringValue)!
        procent = Double(WinPercentage.stringValue)!
        deposit = 0.0
        effectiveness = 0.0
        
        // Функционал
        for i in 1...EditSlider.intValue
        {
            CountingTheTable(lines: Int(i), flag: ChoiceOfStrategy.indexOfSelectedItem-4, flagFractionalNumbers: IntToBool(value: Int8(FlagIntOrDouble.intValue)))
            deposit = deposit + table[1][Int(i)]
            effectiveness = effectiveness + ( table[4][Int(i)] * pow(2.0, Double(EditSlider.intValue+1-i)))
            
        }
        
        // Отображение
        for i in 1...EditSlider.intValue
        {
            TextView1.stringValue = TextView1.stringValue + String(SuperRound(value: table[1][Int(i)], numberOfDecimalPlaces: myRounding)) + "\n"
            TextView2.stringValue = TextView2.stringValue + String(SuperRound(value: table[2][Int(i)], numberOfDecimalPlaces: myRounding)) + "\n"
            TextView3.stringValue = TextView3.stringValue + String(SuperRound(value: table[3][Int(i)], numberOfDecimalPlaces: myRounding)) + "\n"
            TextView4.stringValue = TextView4.stringValue + String(SuperRound(value: table[4][Int(i)], numberOfDecimalPlaces: myRounding)) + "\n"
        }
        TextViewDeposit.stringValue = String(SuperRound(value: deposit, numberOfDecimalPlaces: myRounding))
        TextViewProfit.stringValue = String(SuperRound(value: effectiveness, numberOfDecimalPlaces: myRounding))
        TextViewEfficiency.stringValue = String(SuperRound(value: effectiveness/deposit, numberOfDecimalPlaces: myRounding))
    }
    
    
    
    
    
    
    
    
    
    // --- КНОПКА "Вероятность" --- //
    @IBAction func ButtonVer(_ sender: Any)
    {
        var valueForViewVer = Array (repeating: 0.0, count: 11)
        let temp: Double = 100/EditVer.doubleValue/100
        
        for i in 1...10
        {
            valueForViewVer[i] = 100-pow(temp, Double(i))*100
            valueForViewVer[i] = SuperRound(value: valueForViewVer[i], numberOfDecimalPlaces: Int(SliderVer.intValue))
        }
        ViewVer1.stringValue = String(valueForViewVer[1]) + " %"
        ViewVer2.stringValue = String(valueForViewVer[2]) + " %"
        ViewVer3.stringValue = String(valueForViewVer[3]) + " %"
        ViewVer4.stringValue = String(valueForViewVer[4]) + " %"
        ViewVer5.stringValue = String(valueForViewVer[5]) + " %"
        ViewVer6.stringValue = String(valueForViewVer[6]) + " %"
        ViewVer7.stringValue = String(valueForViewVer[7]) + " %"
        ViewVer8.stringValue = String(valueForViewVer[8]) + " %"
        ViewVer9.stringValue = String(valueForViewVer[9]) + " %"
        ViewVer10.stringValue = String(valueForViewVer[10]) + " %"
    }
    
    
    
    
    
    
    // --- КНОПКА "Дробные или Не дробные"
    @IBAction func ButtonFlagFractionalNumbers(_ sender: Any)
    {
        ChoiseOfStrategy((Any).self) // Вызов функции "ButtonCountingValues"
    }
    
    
    
    // --- КНОПКА "Слайдер Показать"
    @IBOutlet weak var ViewSlider: NSTextField!
    @IBOutlet weak var EditSlider: NSSlider!
    @IBOutlet weak var LabelCountSliderUp: NSTextField!
    @IBOutlet weak var LabelCountSliderDown: NSTextField!
    
    @IBAction func EditSlider(_ sender: Any)
    {
        // НАЧАЛО ГОВНОКОДА отвечающего за отрисовку цифр в панели вывода справа
        ViewSlider.stringValue = "\(EditSlider.intValue)"
        LabelCountSliderDown.stringValue = ""
        LabelCountSliderUp.stringValue = ""
        for i in 1...EditSlider.intValue
        {
                LabelCountSliderUp.stringValue = (LabelCountSliderUp.stringValue + "0\(i)\n")
        }
        if EditSlider.intValue >= 10
        {
            for i in 0...EditSlider.intValue-10
            {
                LabelCountSliderDown.stringValue = (LabelCountSliderDown.stringValue + "1\(i)\n")
            }
        }
        // КОНЕЦ ГОВНОКОДА
        ChoiseOfStrategy((Any).self) // Вызов функции "ButtonCountingValues"
    }
    
    
    
    
    
    // --- КНОПКА "Сдайдер Вероятность"
    @IBAction func SliderVer(_ sender: NSSlider)
    {
        ButtonVer((Any).self) // Вызов функции "ButtonVer"

    }
    
    
    
   
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "MRTNGL v3.0"
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

