import UIKit

// MARK: - Model -
struct Todo {
    var title: String
    var isOn: Bool
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // MARK: - Properties -
    var todoList: [Todo] = [
        Todo(title: "카페가기", isOn: false),
        Todo(title: "과제하기", isOn: false),
        Todo(title: "저녁약속", isOn: false),
        Todo(title: "산책하기", isOn: false)
    ]

    // MARK: - UI -
    @IBOutlet weak var listTableView: UITableView!
    
    // MARK: - View Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listTableView.delegate = self
        listTableView.dataSource = self
        
    }
    
    // MARK: - ETC -
    // 완료 가로선 긋기 함수
    func strikeThrough(title: String) -> NSMutableAttributedString {
        let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: title)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSRange(location: 0, length: attributeString.length))
        return attributeString
    }
    // 수정하기
    func editAction(row: Int) {
        let oldTodo = todoList[row]
        
        let alert = UIAlertController(title: "To-Do 수정", message: "내용을 입력하세요.", preferredStyle: .alert)
        let cancelButton = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        let editButton = UIAlertAction(title: "수정", style: .default) { alertAction in
            guard
                let firstTextField = alert.textFields?[0],
                let newTitle = firstTextField.text
            else { return }
            
            let newTodo = Todo(title: newTitle, isOn: oldTodo.isOn)
            self.todoList[row] = newTodo
            self.listTableView.reloadData()
        }
        
        alert.addAction(cancelButton)
        alert.addAction(editButton)
        alert.addTextField { textField in
            textField.placeholder = "입력해주세요."
            textField.text = oldTodo.title
        }
        
        self.present(alert, animated: true)
    }
   
    // MARK: - objc function -
    @objc func doneAction(_ sender: UISwitch) {
        let row = sender.tag
        todoList[row].isOn.toggle()
        listTableView.reloadData()
        
        print("눌림 \(sender.tag)")
    }
    
    // MARK: - Action -
    // 추가하기
    @IBAction func addButtonClicked(_ sender: Any) {
        let alert = UIAlertController(title: "TO-DO 등록", message: "내용을 입력하세요.", preferredStyle: .alert)
        // "등록" 버튼 추가
        let registerButton = UIAlertAction(title: "등록", style: .default, handler: { [weak self] _ in
            guard let newTitle = alert.textFields?[0].text else { return }
            // - 새로운 Todo 추가하기
            let newTodo = Todo(title: newTitle, isOn: false)
            self?.todoList.append(newTodo)
            self?.listTableView.reloadData()
        })
        
        // "취소" 버튼 추가
        let cancelButton = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(cancelButton)
        alert.addAction(registerButton)
        
        // textField 추가
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "할 일을 입력해주세요."
        })
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - UITableViewDelegate, UITableViewDataSource -
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "listTableViewCell", for: indexPath) as? ListTableViewCell else { return UITableViewCell() }
        
        cell.doneSwitch.addTarget(self, action: #selector(doneAction), for: .valueChanged)
        cell.doneSwitch.tag = indexPath.row
        let row = indexPath.row
        let todo = todoList[row]
        cell.doneSwitch.isOn = todo.isOn
        cell.doneSwitch.onTintColor = .systemPink
        if cell.doneSwitch.isOn {
            cell.titleLabel.attributedText = strikeThrough(title: todo.title)
            cell.titleLabel.textColor = .systemPink
        }
        else {
            cell.titleLabel.attributedText = nil
            cell.titleLabel.text = todo.title
            cell.titleLabel.textColor = .black
        }
        
        return cell
    }
    
    // 삭제하기
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.todoList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // 수정하기
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        editAction(row: indexPath.row)
    }
}

// MARK: - ListTableViewCell -
class ListTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var doneSwitch: UISwitch!
}

