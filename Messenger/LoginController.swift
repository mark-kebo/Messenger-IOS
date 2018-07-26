//
//  LoginController.swift
//  Messenger
//
//  Created by Dmitry Vorozhbicky on 09.07.2018.
//  Copyright © 2018 Dmitry Vorozhbicky. All rights reserved.
//
//  1.Создание: метод init, вызовет initWithNibName - без view
//  2.loadView-загрузит view из xib файла, либо создаст пустой UIView
//  3.viewDidLoad-сразу после загрузки view(тут допиливается то,что не попало во view)
//  4.viewWillAppear и viewDidAppear - до и после появления view на экране-размеры экрана напр
//  5.viewWillDisappear и viewDidDisappear - до и после исчезновения view на экране
//  6.didReceiveMemoryWarning-при нехватке памяти
//  7.dealloc-уничтожение
//  public - использовать объекты внутри любого исходного файла из определяющего их модуля и так же в любом исходном файле из другого модуля, который импортирует определяющий модуль
//  internal(по умолчанию) - использовать объекты внутри любого исходного файла из их определяющего модуля, но не исходного файла не из этого модуля
//  file private - использовать объект в пределах его исходного файла
//  private - использовать сущность только в пределах области ее реализации
//  open - рассмотрели влияние кода других модулей, использующих этот класс в качестве суперкласса
//  window, delegate
//        (self.view as? LoginPasswordView)?.button
//  extansion
//  constr...

import UIKit
import VK_ios_sdk

class LoginController: UIViewController, VKSdkDelegate, VKSdkUIDelegate  {
    private let appId = "6637865"
    private let SCOPE = [VK_PER_FRIENDS, VK_PER_MESSAGES, VK_PER_EMAIL, VK_PER_PHOTOS]
    
    func vkSdkShouldPresent(_ controller: UIViewController!) {
        print("vkSdkShouldPresent")
        present(controller!, animated: false, completion: nil)
    }
    
    func vkSdkNeedCaptchaEnter(_ captchaError: VKError!) {
        print("vkSdkNeedCaptchaEnter")
    }
    
    func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!) {
        print("vkSdkAccessAuthorizationFinished")
        print(result.token)
    }
    
    func vkSdkUserAuthorizationFailed() {
        print("vkSdkUserAuthorizationFailed")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let sdkInstance = VKSdk.initialize(withAppId: appId)
        sdkInstance?.register(self)
        sdkInstance?.uiDelegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        VKSdk.wakeUpSession(SCOPE, complete: { (state, error) -> Void in
            if (state == VKAuthorizationState.authorized) {
                self.goToNextController()
            } else if ((error) != nil) {
                print("ERROR: \(error as! String)")
            } else {
                VKSdk.authorize(self.SCOPE, with: .disableSafariController)
            }
        })
    }
    
    private func goToNextController() {
        let secondViewController: ConnectedViewController = ConnectedViewController()
        self.present(secondViewController, animated: true, completion: nil)
    }
}
