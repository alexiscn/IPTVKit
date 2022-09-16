import UIKit
import IPTVKit
import AVKit

class ViewController: UIViewController {

    enum Section { case main }
    
    var collectionView: UICollectionView!
    
    var dataSource: UICollectionViewDiffableDataSource<Section, PlaylistItem>!
    
    let loadingIndicator = UIActivityIndicatorView(style: .medium)
    
    var playlist: Playlist?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        setupLoadingIndicator()
        setupDataSource()
        applySnapshot()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        loadingIndicator.center = view.center
    }

    private func setupCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.delegate = self
        view.addSubview(collectionView)
    }

    private func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout.list(using: .init(appearance: .insetGrouped))
    }
    
    private func setupDataSource() {
        let registration = UICollectionView.CellRegistration<UICollectionViewListCell, PlaylistItem> { (cell, indexPath, item) in
            var content = cell.defaultContentConfiguration()
            content.text = item.name
            cell.contentConfiguration = content
        }
        dataSource = UICollectionViewDiffableDataSource<Section, PlaylistItem>(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            return collectionView.dequeueConfiguredReusableCell(using: registration, for: indexPath, item: itemIdentifier)
        })
    }
    
    private func applySnapshot() {
        Task {
            do {
                loadingIndicator.startAnimating()
                
                let playlist = try await loadPlaylist()
                self.playlist = playlist
                
                var snapshot = NSDiffableDataSourceSnapshot<Section, PlaylistItem>()
                snapshot.appendSections([.main])
                snapshot.appendItems(playlist.items, toSection: .main)
                dataSource.apply(snapshot)
                
                loadingIndicator.stopAnimating()
            } catch {
                print(error)
            }
        }
    }
    
    private func setupLoadingIndicator() {
        view.addSubview(loadingIndicator)
    }
    
    private func loadPlaylist() async throws -> Playlist {
        try await withUnsafeThrowingContinuation({ ct in
            let url = URL(string: "https://raw.githubusercontent.com/vamoschuck/TV/main/M3U")!
            let name = "vamoschuck"
            let request = URLRequest(url: url)
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    ct.resume(throwing: error)
                } else if let data = data, let text = String(data: data, encoding: .utf8) {
                    if let playlist = IPTVKit.Parser.parse(text: text, name: name, url: url) {
                        ct.resume(returning: playlist)
                    } else {
                        ct.resume(throwing: NSError())
                    }
                } else {
                    ct.resume(throwing: NSError())
                }
            }.resume()
        })
    }
    
    private func loadEPG() async throws {
        
    }
}

extension ViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath) else {
            return
        }
        
        guard let url = URL(string: item.url) else {
            return
        }
        
        let player = AVPlayer(url: url)
        let viewController = AVPlayerViewController()
        viewController.player = player
        player.play()
        present(viewController, animated: true)
    }
    
}
