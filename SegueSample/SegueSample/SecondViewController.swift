//
//  SecondViewController.swift
//  SegueSample
//
//  Created by Yusk1450 on 2017/07/21.
//  Copyright © 2017年 Yusk. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController
{
	var text:String?
	@IBOutlet weak var label: UILabel!

	override func viewDidLoad()
	{
        super.viewDidLoad()
		
		self.label.text = self.text
    }
	
	@IBAction func returnBtnAction(_ sender: Any)
	{
		self.dismiss(animated: true, completion: nil)
	}

    override func didReceiveMemoryWarning()
	{
        super.didReceiveMemoryWarning()
    }
}
