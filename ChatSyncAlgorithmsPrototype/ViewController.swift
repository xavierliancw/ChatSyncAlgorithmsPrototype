//
//  ViewController.swift
//  ChatSyncAlgorithmsPrototype
//
//  Created by Xavier Lian on 4/13/18.
//  Copyright © 2018 XavierLian. All rights reserved.
//

import UIKit

struct DataThing: Hashable, Comparable, Equatable
{
    let value: Int
    var color: UIColor
    var hashValue: Int {return value}
    static func < (lhs: DataThing, rhs: DataThing) -> Bool {return lhs.value < rhs.value}
    static func ==(lhs: DataThing, rhs: DataThing) -> Bool
    {
        return lhs.value == rhs.value && lhs.color == rhs.color
    }
}

class ViewController: UIViewController
{
    //MARK: Properties
    
    var currentData = [DataThing]()
    var incomingData = [DataThing]()
    var expectedData = [DataThing]()
    var resultData = [DataThing]()
    let CURRENTID = "current"
    let INCOMINGID = "incoming"
    let EXPECTEDID = "expected"
    let RESULTID = "result"
    
    //MARK: UI Elements
    
    let resetBt = UIButton()
    let performBt = UIButton()
    let currentLbl = UILabel()
    let incomingLbl = UILabel()
    let expectedLbl = UILabel()
    let resultLbl = UILabel()
    var currentCV: UICollectionView!
    var incomingCV: UICollectionView!
    var expectedCV: UICollectionView!
    var resultCV: UICollectionView!
    
    //MARK:- Functions
    
    func setUpAndPlaceResetBt()
    {
        resetBt.setTitle("Generate New Data And Reset", for: .normal)
        resetBt.backgroundColor = .red
        resetBt.addTarget(self, action: #selector(reset), for: .touchUpInside)
        view.addSubview(resetBt)
        resetBt.translatesAutoresizingMaskIntoConstraints = false
        resetBt.heightAnchor.constraint(equalToConstant: 50).isActive = true
        resetBt.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        resetBt.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        resetBt.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
    }
    
    @objc func reset()
    {
        var randomSet1 = [Int]()
        var randomSet2 = [Int]()
        
        //Clear data
        currentData.removeAll()
        incomingData.removeAll()
        expectedData.removeAll()
        resultData.removeAll()
        
        //Generate 2 arrays of random numbers
        for _ in 0 ..< Int(arc4random_uniform(11))
        {
            randomSet1.append(Int(arc4random_uniform(UInt32(10))))
            randomSet2.append(Int(arc4random_uniform(10)))
        }
        //Data should all be unique and sorted
        randomSet1 = Array(Set(randomSet1)).sorted()
        randomSet2 = Array(Set(randomSet2)).sorted()
        
        //Populate current
        for number in randomSet1
        {
            currentData.append(newData(from: number)) //Can have white or red values
        }
        //Populate incoming
        for number in randomSet2
        {
            incomingData.append(newData(from: number, forceWhite: true)) //Incoming data is white
        }
        //If a DataThing object's value in currentData is red and exists in incomingData,
        //then it should turn white in the expected data
        expectedData = incorporate(sortedUpdate: incomingData, intoSortedModel: currentData,
                                   updateCondition: {$0.value == $1.value && $0.color != $1.color})
        
        //Result data is the same as current until the batch update occurs
        resultData = currentData
        resultLbl.text = "Before Updates"
        
        //Refresh all views
        currentCV.reloadData()
        incomingCV.reloadData()
        expectedCV.reloadData()
        resultCV.reloadData()
    }
    
    func newData(from value: Int, forceWhite: Bool = false) -> DataThing
    {
        var whiteOrRed: UIColor = .white
        if Int(arc4random_uniform(2)) == 1 && !forceWhite
        {
            whiteOrRed = .red
        }
        return DataThing(value: value, color: whiteOrRed)
    }
    
    func setUpAndPlacePerformBt()
    {
        performBt.setTitle("Perform Batch Updates", for: .normal)
        performBt.backgroundColor = .blue
        performBt.addTarget(self, action: #selector(performUpdate), for: .touchUpInside)
        view.addSubview(performBt)
        performBt.translatesAutoresizingMaskIntoConstraints = false
        performBt.bottomAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.bottomAnchor
            ).isActive = true
        performBt.heightAnchor.constraint(equalToConstant: 50).isActive = true
        performBt.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        performBt.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    @objc func performUpdate()
    {
        print("performing update not yet implemented")
    }
    
    func setUpAndPlaceCVLbls()
    {
        currentLbl.text = "Current\nModel"
        currentLbl.textColor = .white
        currentLbl.backgroundColor = .black
        currentLbl.textAlignment = .center
        currentLbl.numberOfLines = 0
        view.addSubview(currentLbl)
        currentLbl.translatesAutoresizingMaskIntoConstraints = false
        currentLbl.topAnchor.constraint(equalTo: resetBt.bottomAnchor).isActive = true
        currentLbl.widthAnchor.constraint(equalTo: view.widthAnchor,
                                          multiplier: 0.25).isActive = true
        currentLbl.heightAnchor.constraint(equalToConstant: 50).isActive = true
        currentLbl.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        
        incomingLbl.text = "Incoming\nData"
        incomingLbl.textColor = .white
        incomingLbl.backgroundColor = .black
        incomingLbl.numberOfLines = 0
        incomingLbl.textAlignment = .center
        view.addSubview(incomingLbl)
        incomingLbl.translatesAutoresizingMaskIntoConstraints = false
        incomingLbl.topAnchor.constraint(equalTo: resetBt.bottomAnchor).isActive = true
        incomingLbl.widthAnchor.constraint(equalTo: view.widthAnchor,
                                           multiplier: 0.25).isActive = true
        incomingLbl.heightAnchor.constraint(equalToConstant: 50).isActive = true
        incomingLbl.leadingAnchor.constraint(equalTo: currentLbl.trailingAnchor).isActive = true
        
        expectedLbl.text = "Expected\nResult"
        expectedLbl.textColor = .white
        expectedLbl.backgroundColor = .black
        expectedLbl.numberOfLines = 0
        expectedLbl.textAlignment = .center
        view.addSubview(expectedLbl)
        expectedLbl.translatesAutoresizingMaskIntoConstraints = false
        expectedLbl.topAnchor.constraint(equalTo: resetBt.bottomAnchor).isActive = true
        expectedLbl.widthAnchor.constraint(equalTo: view.widthAnchor,
                                           multiplier: 0.25).isActive = true
        expectedLbl.heightAnchor.constraint(equalToConstant: 50).isActive = true
        expectedLbl.leadingAnchor.constraint(equalTo: incomingLbl.trailingAnchor).isActive = true
        
        resultLbl.text = "Before\nUpdates"
        resultLbl.textColor = .white
        resultLbl.backgroundColor = .black
        resultLbl.numberOfLines = 0
        resultLbl.textAlignment = .center
        view.addSubview(resultLbl)
        resultLbl.translatesAutoresizingMaskIntoConstraints = false
        resultLbl.topAnchor.constraint(equalTo: resetBt.bottomAnchor).isActive = true
        resultLbl.widthAnchor.constraint(equalTo: view.widthAnchor,
                                         multiplier: 0.25).isActive = true
        resultLbl.heightAnchor.constraint(equalToConstant: 50).isActive = true
        resultLbl.leadingAnchor.constraint(equalTo: expectedLbl.trailingAnchor).isActive = true
    }
    
    func setUpAndPlaceCollectionViews()
    {
        currentCV = UICollectionView(frame: .zero,
                                     collectionViewLayout: UICollectionViewFlowLayout())
        currentCV.backgroundColor = .gray
        setup(cv: currentCV, id: CURRENTID)
        currentCV.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        
        incomingCV = UICollectionView(frame: .zero,
                                      collectionViewLayout: UICollectionViewFlowLayout())
        incomingCV.backgroundColor = .orange
        setup(cv: incomingCV, id: INCOMINGID)
        incomingCV.leadingAnchor.constraint(equalTo: currentCV.trailingAnchor).isActive = true
        
        expectedCV = UICollectionView(frame: .zero,
                                      collectionViewLayout: UICollectionViewFlowLayout())
        expectedCV.backgroundColor = UIColor.purple
        setup(cv: expectedCV, id: EXPECTEDID)
        expectedCV.leadingAnchor.constraint(equalTo: incomingCV.trailingAnchor).isActive = true
        
        resultCV = UICollectionView(frame: .zero,
                                    collectionViewLayout: UICollectionViewFlowLayout())
        resultCV.backgroundColor = .green
        setup(cv: resultCV, id: RESULTID)
        resultCV.leadingAnchor.constraint(equalTo: expectedCV.trailingAnchor).isActive = true
    }
    
    func setup(cv: UICollectionView, id: String)
    {
        if let flow = cv.collectionViewLayout as? UICollectionViewFlowLayout
        {
            flow.minimumLineSpacing = 3
            flow.minimumInteritemSpacing = 3
        }
        cv.delegate = self
        cv.dataSource = self
        cv.alwaysBounceVertical = true
        cv.register(LblCell.self, forCellWithReuseIdentifier: id)
        view.addSubview(cv)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.topAnchor.constraint(equalTo: currentLbl.bottomAnchor).isActive = true
        cv.bottomAnchor.constraint(equalTo: performBt.topAnchor).isActive = true
        cv.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.25).isActive = true
    }
    
    //MARK:- UI Business
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUpAndPlaceResetBt()
        setUpAndPlacePerformBt()
        setUpAndPlaceCVLbls()
        setUpAndPlaceCollectionViews()
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        reset()
    }
}

//MARK:- Collection View Delegate

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int
    {
        switch collectionView
        {
        case currentCV:
            return currentData.count
        case incomingCV:
            return incomingData.count
        case expectedCV:
            return expectedData.count
        case resultCV:
            return resultData.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        switch collectionView
        {
        case currentCV:
            if let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CURRENTID, for: indexPath
                ) as? LblCell,
                0 ..< currentData.count ~= indexPath.item
            {
                cell.lbl.text = String(currentData[indexPath.item].value)
                cell.backgroundColor = currentData[indexPath.item].color
                return cell
            }
        case incomingCV:
            if let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: INCOMINGID, for: indexPath
                ) as? LblCell,
                0 ..< incomingData.count ~= indexPath.item
            {
                cell.lbl.text = String(incomingData[indexPath.item].value)
                cell.backgroundColor = incomingData[indexPath.item].color
                return cell
            }
        case expectedCV:
            if let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: EXPECTEDID, for: indexPath
                ) as? LblCell,
                0 ..< expectedData.count ~= indexPath.item
            {
                cell.lbl.text = String(expectedData[indexPath.item].value)
                cell.backgroundColor = expectedData[indexPath.item].color
                return cell
            }
        case resultCV:
            if let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: RESULTID, for: indexPath
                ) as? LblCell,
                0 ..< resultData.count ~= indexPath.item
            {
                cell.lbl.text = String(resultData[indexPath.item].value)
                cell.backgroundColor = resultData[indexPath.item].color
                return cell
            }
        default:
            break
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: collectionView.bounds.width - 6, height: 21)
    }
}

//MARK:- Custom Cell UI

class LblCell: UICollectionViewCell
{
    var lbl = UILabel()
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        setup()
    }
    
    override func prepareForReuse()
    {
        super.prepareForReuse()
        lbl.text = ""
        backgroundColor = .clear
    }
    
    private func setup()
    {
        addSubview(lbl)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        lbl.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        lbl.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        lbl.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
    }
}
