//
//  ViewController.swift
//  SegueSample
//
//  Created by Yusk1450 on 2017/07/19.
//  Copyright © 2017年 Yusk. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate
{
	@IBOutlet weak var textField: UITextField!

	override func viewDidLoad()
	{
		super.viewDidLoad()
	}

	override func didReceiveMemoryWarning()
	{
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool
	{
		self.textField.resignFirstResponder()
		return true
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?)
	{
		let nextViewController = segue.destination as? SecondViewController
		nextViewController?.text = self.textField.text
	}
}

