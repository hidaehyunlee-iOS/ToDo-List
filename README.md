> 👆🏻 여기 햄버거 버튼을 눌러 목차를 확인하세요.

## 01. 개요

- **개발기간**: 2023-08-07(월) ~ 10(목)
- **프로젝트 소개**: 간단한 To Do 리스트 앱의 로직을 구현했으며, 할 일을 조회하고, 추가하고, 삭제하고, 완료한 일에는 체크마크를 표시해 따로 관리할 수 있는 기능을 포함합니다.
- **기술 구조 요약**
  - **UI**: `UIKit`, `Storyboard`
    - `UINavigationController`
    - `UIAlertController`
    - `UITableView`
    - `UISegmentedControl`
    - `UIButton`
    - `UITextField`
    - `Auto Layout`
  - **Architecture**: `MVC`
  - **Data Storage**: `UserDefaults`


## 02. 구현 기능

<img width="2013" alt="image" src="https://github.com/hidaehyunlee-iOS/ToDo-List/assets/37580034/9a731d29-f62f-4df1-b1ee-9137fe90a813">

#### 2.1. TodoListViewController

> 유저의 할 일 목록과 완료한 일 목록을 보여주고 관리합니다.

- 세그먼트 컨트롤을 통해 '할 일'과 '완료한 일' 리스트를 전환할 수 있습니다.
- 할 일을 완료한 경우 체크마크가 표시됩니다.
- 할 일을 선택하면 완료 상태를 변경하고, alert를 통해 유저에게 할 일이 완료되었음을 알립니다.
- 할 일을 스와이프하여 삭제할 수 있습니다.
- `+` 버튼을 눌러 `EntryViewController`로 이동하여 새로운 할 일을 추가할 수 있습니다.
- userDefaults를 통해 앱을 종료해도 사용자 데이터를 유지시킵니다.

#### 2.2. EntryViewController

> 새로운 할 일을 입력받아 TodoList에 추가합니다.
>>>>>>> d20f0a35e6520229bb379ac970df858ed9037708

- `UITextField`에 할 일 텍스트 입력 후 '저장' 버튼을 누르거나 키보드의 Return 키를 누르면 할 일을 TodoList에 추가합니다.
- `didAddHandler` 클로저를 호출하여 할 일 추가가 완료되었음을 알립니다.
- 할 일이 추가되면 `tasks` 배열에 새로운 할 일 객체를 추가하고, TodoList 화면으로 pop 합니다.


<br>

## 03. 핵심 경험

> 구현 시 어려웠던 기술적인 부분을 블로그에 정리했습니다. 

- [Storyboard Reference](https://velog.io/@hidaehyunlee/스토리보드로-협업-시-Git-충돌-해결하기-Storyboard-Reference-bqm6w0n2)
- UITableView reloadData 시점
- 하나의 tableView에서 각기 다른 데이터를 관리하는 작업 
  - IndexPath 개념
- UIButton을 코드로 작성하고 이미지 크기를 키우는 방법
- 데이터 관리 (UserDefaults)
- completion handler
