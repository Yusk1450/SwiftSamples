//
//  ViewController.swift
//  TableViewSample
//
//  Created by Yusk1450 on 2017/10/13.
//  Copyright © 2017年 Yusk. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
	// テーブルビューの中身を配列として用意しておく
	let contents = ["aaa", "bbb", "ccc", "ddd"]
	
	override func viewDidLoad()
	{
		super.viewDidLoad()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	func numberOfSections(in tableView: UITableView) -> Int
	{
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
	{
		// セルの数を返す
		return self.contents.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
	{
		// セルの名前
		let identifier = "Basic-Cell"
		// セルの再利用
		var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
		
		if (cell == nil)
		{
			cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: identifier)
		}
		
		// セルのラベルに文字を入れる
		cell?.textLabel?.text = self.contents[indexPath.row]
		
		// 強制アンラップ
		return cell!
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
	{
		// 選択したセルの名前を取得
		let cellTitle = self.contents[indexPath.row]
		// アラートを作成する
		let alert = UIAlertController(title: "お知らせ",
		                              message: cellTitle,
		                              preferredStyle: UIAlertControllerStyle.actionSheet)
		// キャンセルボタンを作成する
		let cancelAction = UIAlertAction(title: "閉じる",
		                                 style: UIAlertActionStyle.cancel,
		                                 handler: nil)
		// キャンセルボタンをアラートに追加する
		alert.addAction(cancelAction)
		
		// アラートを表示する
		self.present(alert, animated: true, completion: nil)
		
		// 選択の色を解除する
		tableView.deselectRow(at: indexPath, animated: true)
	}

}

