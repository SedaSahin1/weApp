//
//  WeatherRouter.swift
//  WeatherApp
//
//  Created by Seda Şahin on 17.02.2024.
//

import Foundation
import UIKit

protocol WeatherRouterProtocol {
    var entry : WeatherViewController? {get}
    static func startExecution() -> WeatherRouterProtocol
    func navigateToNextScreen(view: WeatherViewController, list: List)
}

class WeatherRouter: WeatherRouterProtocol {
    var entry: WeatherViewController?
    static func startExecution() -> WeatherRouterProtocol {
        let storyboard = UIStoryboard(name: "Weather", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "WeatherViewController") as! WeatherViewController
        let router = WeatherRouter()
        var interactor : WeatherInteractorProtocol = WeatherInteractor()
        var view : WeatherViewProtocol = WeatherViewController()
        var presenter : WeatherPresenterProtocol = WeatherPresenter()
        view.presenter = presenter
        presenter.viewController = controller
        presenter.router = router
        presenter.interactor = interactor
        interactor.presenter = presenter
        router.entry = controller as? WeatherViewController
        return router
    }
    
    func navigateToNextScreen(view: WeatherViewController, list: List){
        let storyboard = UIStoryboard(name: "Weather", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "WeatherDetailViewController") as! WeatherDetailViewController
        controller.list = list
        view.navigationController?.pushViewController(controller, animated: true)
    }
}
