import UIKit

class DetailViewController: UIViewController {  // , SecretDetailsDelegate // sklonjeno jer ce ovu funkcionalnost preuzeti koordinator
    
    
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var ageLabel: UILabel!
    @IBOutlet var genderLabel: UILabel!
    
    fileprivate weak var navigationCoordinator: NavigationCoordinator?
    
    fileprivate var presenter: DetailPresenter!
    
//    fileprivate var secretDetailsViewControllerMaker: DependencyRegistry.SecretDetailsViewControllerMaker!  // ovo mi vise ne treba zbog koordinatora
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        presenter = DetailPresenter()
        setupView()
    }

//    func configure(with presenter: DetailPresenter, secretDetailsViewControllerMaker: @escaping DependencyRegistry.SecretDetailsViewControllerMaker) {
//        self.presenter = presenter
//        self.secretDetailsViewControllerMaker = secretDetailsViewControllerMaker
//    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if isMovingFromParentViewController {
            navigationCoordinator?.movingBack()
        }
    }
    
    func configure(with presenter: DetailPresenter, navigationCoordinator: NavigationCoordinator) {
        self.presenter = presenter
        self.navigationCoordinator = navigationCoordinator
    }
    
    func setupView() {
        profileImage.image = UIImage(named: presenter.imageName)
        nameLabel.text = presenter.name
        ageLabel.text  = presenter.age
        genderLabel.text = presenter.gender
    }
}

//MARK: - Touch Events
extension DetailViewController {
    @IBAction func briefcaseTapped(_ button: UIButton) {
        // za kreiranje VC nisma vise zaduzen ja nego DI
//        let secretDetailsPresenter = SecretDetailsPresenter(with: presenter.spy)
//        let vc = SecretDetailsViewController(with: secretDetailsPresenter, and: self as SecretDetailsDelegate)
        
        // ovo mi ne treba vise jer cu odavde obavestiti koordinator da treba da pushuje novi VC
//        let vc = secretDetailsViewControllerMaker(presenter.spy, self)
//        navigationController?.pushViewController(vc, animated: true)
        
        let args = ["spy":presenter.spy!]
        navigationCoordinator!.next(arguments: args)
    }
}


// OVO MI TAKODJE VISE NE TREBA JER CE O OVOME BRINUTI KOORDINATOR
////MARK: - SecretDetailsDelegate
//extension DetailViewController {
//    func passwordCrackingFinished() {
//        //close middle layer too
//        navigationController?.popViewController(animated: true)
//    }
//}
//


//MARK: - Helper Methods - ne treba mi vise jer ce za ovo biti zaduzen DI, tj SwinjectStoryboard
//extension DetailViewController {
//    static func fromStoryboard(with presenter: DetailPresenter) -> DetailViewController {
//        let vc = UIStoryboard.main.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
//            vc.configure(with: presenter)
//
//        return vc
//    }
//}

