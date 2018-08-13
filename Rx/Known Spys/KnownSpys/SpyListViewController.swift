import UIKit
import Toaster
import RxSwift
import RxDataSources
import RxCocoa

class SpyListViewController: UIViewController, UITableViewDelegate { // , UITableViewDataSource // skinuo zbog RX

    @IBOutlet var tableView: UITableView!
    
    weak var navigationCoordinator: NavigationCoordinator?
    
    fileprivate var presenter: SpyListPresenter!
    
//    fileprivate var detailViewControllerMaker: DependencyRegistry.DetailViewControllerMaker! // ovaj sklanjam sad jer ulogu preuzima koordinator
    fileprivate var spyCellMaker: DependencyRegistry.SpyCellMaker!
    fileprivate var bag = DisposeBag()
    
    fileprivate var dataSource = RxTableViewSectionedReloadDataSource<SpySection>()
    
//    func configure(with presenter: SpyListPresenter, detailViewControllerMaker: @escaping DependencyRegistry.DetailViewControllerMaker, spyCellMaker: @escaping DependencyRegistry.SpyCellMaker) {
//        self.presenter = presenter
//        self.detailViewControllerMaker = detailViewControllerMaker
//        self.spyCellMaker = spyCellMaker
//    }
    
    func configure(with presenter: SpyListPresenter, navigationCoordinator: NavigationCoordinator, spyCellMaker: @escaping DependencyRegistry.SpyCellMaker) {
        self.presenter = presenter
        self.navigationCoordinator = navigationCoordinator
        self.spyCellMaker = spyCellMaker
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Rx
//        tableView.dataSource = self
//        tableView.delegate   = self
        
//        presenter = SpyListPresenter()  // ovo ovde vise necu jer necu da budem odgovoran za njegovo kreiranje, za to ce biti odgovoran DI
        
        SpyCell.register(with: tableView)
        
        presenter.loadData { [weak self] source in
            self?.newDataReceived(from: source)
        }
        
        initDataSource()
        initTableView()
    }
    
    func newDataReceived(from source: Source) {
        Toast(text: "New Data from \(source)").show()
        tableView.reloadData()
    }
    
    @IBAction func updateData(_ sender: Any) {
        presenter.makeSomeDataChange()
    }
}

//MARK: - Rx
extension SpyListViewController {
    func initDataSource() {
        dataSource.configureCell = { _, tableView, indexPath, spy in
            let cell = self.spyCellMaker(tableView,indexPath, spy)
            return cell
        }
        
        dataSource.titleForHeaderInSection = { ds, index in
            return ds.sectionModels[index].header
        }
    }
    
    func initTableView() {
        presenter.sections.asObservable()
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: bag)
        
        tableView.rx.itemSelected.map { indexPath in
            return (indexPath, self.dataSource[indexPath])
            }.subscribe(onNext: { indexPath, spy in
                self.next(with: spy)
            }).disposed(by: bag)
        
        tableView.rx.setDelegate(self)
            .disposed(by: bag)
    }
}

//MARK: - UITableViewDataSource - Rx ce bitizaaduzen za ovo
//extension SpyListViewController {
//
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return presenter.data.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let spy = presenter.data[indexPath.row]
//
////        let cell = SpyCell.dequeue(from: tableView, for: indexPath, with: spy)
//        let cell = spyCellMaker(tableView, indexPath, spy)
//
//        return cell
//    }
//}

//MARK: - UITableViewDelegate
extension SpyListViewController {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 126
    }
    
    
    // RX - ovo mi vise ne treba zbog RX-a
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let spy = presenter.data[indexPath.row]
//
//        // Ovo mi vise ne treba jer necu vise ja kreirati VC vec ce ga kreirati DI
////        let detailPresenter = DetailPresenter(with: spy)
////        let detailViewController = DetailViewController.fromStoryboard(with: detailPresenter)
//
//        // Ovo mi vise ne treba jer cu odavde obavestiti koordinatora da hocu da pushujem novi kontroler
////        let detailViewController = detailViewControllerMaker(spy)
////        navigationController?.pushViewController(detailViewController, animated: true)
//
//        next(with: spy)
//    }
    
    func next(with spy: SpyDTO) {
        let args = ["spy": spy]
        navigationCoordinator!.next(arguments: args)
    }
    
}



