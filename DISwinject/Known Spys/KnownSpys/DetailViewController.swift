import UIKit

class DetailViewController: UIViewController, SecretDetailsDelegate {
    
    
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var ageLabel: UILabel!
    @IBOutlet var genderLabel: UILabel!
    
    fileprivate var presenter: DetailPresenter!
    
    fileprivate var secretDetailsViewControllerMaker: DependencyRegistry.SecretDetailsViewControllerMaker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        presenter = DetailPresenter()
        setupView()
    }

    func configure(with presenter: DetailPresenter, secretDetailsViewControllerMaker: @escaping DependencyRegistry.SecretDetailsViewControllerMaker) {
        self.presenter = presenter
        self.secretDetailsViewControllerMaker = secretDetailsViewControllerMaker
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
//        let secretDetailsPresenter = SecretDetailsPresenter(with: presenter.spy)
//        let vc = SecretDetailsViewController(with: secretDetailsPresenter, and: self as SecretDetailsDelegate)
        // za kreiranje VC nisma vise zaduzen ja nego DI
        let vc = secretDetailsViewControllerMaker(presenter.spy, self)
        
        navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - SecretDetailsDelegate
extension DetailViewController {
    func passwordCrackingFinished() {
        //close middle layer too
        navigationController?.popViewController(animated: true)
    }
}


//MARK: - Helper Methods - ne treba mi vise jer ce za ovo biti zaduzen DI, tj SwinjectStoryboard
//extension DetailViewController {
//    static func fromStoryboard(with presenter: DetailPresenter) -> DetailViewController {
//        let vc = UIStoryboard.main.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
//            vc.configure(with: presenter)
//
//        return vc
//    }
//}

