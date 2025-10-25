# SwiftCodingConventions
SwiftCodingConventions 문서를 토대로 한 샘플 프로젝트



# Swift Coding Conventions

> Swift API Design Guidelines 기반 실무 코딩 컨벤션
> 원칙: 사용 시점의 명확성 > 간결함

---

## 목차

1. [네이밍 규칙](#1-네이밍-규칙)
2. [함수와 메서드](#2-함수와-메서드)
3. [프로퍼티](#3-프로퍼티)
4. [타입 정의](#4-타입-정의)
5. [매개변수와 인수 레이블](#5-매개변수와-인수-레이블)
6. [문서화](#6-문서화)
7. [코드 스타일](#7-코드-스타일)
8. [체크리스트](#8-체크리스트)
9. [실전 예제](#9-실전-예제)
10. [참고 자료](#10-참고-자료)

---

## 1. 네이밍 규칙

### 1.1 케이스 규칙

```swift
class UserManager { }
struct BookModel { }
protocol DataSource { }
enum NetworkError { }

var userName: String
func fetchData() { }
let maxRetryCount = 3
```

### 1.2 약어 처리

```swift
var htmlParser: HTMLParser
var utf8Bytes: [UTF8.CodeUnit]
var userID: String
var urlString: String
```

### 1.3 역할 중심 네이밍

```swift
var greeting = "Hello"
var welcomeScreen = UIViewController()
func remove(_ member: Element)
```

### 1.4 불필요한 단어 생략

```swift
public mutating func remove(_ member: Element)
allViews.remove(cancelButton)
```

---

## 2. 함수와 메서드

### 2.1 사이드 이펙트에 따른 네이밍

```swift
mutating func sort()
mutating func append(_ element: Element)
func printDocument()
```

```swift
func sorted() -> [Element]
func appending(_ element: Element) -> [Element]
func distance(to other: Point) -> Double
```

### 2.2 Mutating/Nonmutating 쌍

```swift
mutating func sort()
func sorted() -> Self
```

### 2.3 팩토리 메서드

```swift
func makeIterator() -> Iterator
static func makeRandom() -> Self
class func makeDefault() -> Configuration
```

### 2.4 영문 문장처럼 읽히게

```swift
list.insert(element, at: index)
view.addSubview(child)
array.remove(at: 5)
```

---

## 3. 프로퍼티

### 3.1 Boolean 프로퍼티

```swift
var isEmpty: Bool
var isHidden: Bool
var hasChildren: Bool
var canEdit: Bool
var shouldRefresh: Bool
```

### 3.2 Boolean 메서드

```swift
func isEmpty() -> Bool
func contains(_ element: Element) -> Bool
func intersects(_ other: Shape) -> Bool
```

### 3.3 계산 프로퍼티 복잡도 문서화

```swift
/// Returns the sum of all elements.
/// - Complexity: O(n)
var sum: Int { reduce(0, +) }

/// Returns the first element.
/// - Complexity: O(1)
var first: Element? { isEmpty ? nil : self[startIndex] }
```

---

## 4. 타입 정의

### 4.1 프로토콜 네이밍

```swift
protocol Collection { }
protocol Sequence { }
protocol ViewController { }
protocol Equatable { }
protocol Comparable { }
protocol Codable { }
protocol ProgressReporting { }
```

### 4.2 열거형

```swift
enum NetworkError {
    case connectionFailed
    case invalidResponse
    case timeout
}
```

### 4.3 제네릭 타입 매개변수

```swift
struct Dictionary<Key: Hashable, Value> { }
func map<Transformed>(_ transform: (Element) -> Transformed) -> [Transformed]
struct Stack<Element> { }
func swap<T>(_ a: inout T, _ b: inout T)
```

---

## 5. 매개변수와 인수 레이블

### 5.1 기본 규칙

```swift
func move(from start: Point, to end: Point)
object.move(from: startPoint, to: endPoint)
```

### 5.2 첫 번째 인수 레이블

* 값 보존 타입 변환 → 레이블 생략

```swift
let text = String(42)
let hex = String(255, radix: 16)
```

* 문법적 구의 일부 → 레이블 생략

```swift
view.addSubview(button)
array.append(element)
words.split(maxSplits: 5)
```

* 필요한 경우 레이블 작성

```swift
array.remove(at: index)
list.insert(element, at: position)
boxes.removeBoxes(havingLength: 5)
point.moveTo(x: 10, y: 20)
color.fadeFrom(red: 0, green: 0, blue: 0)
```

### 5.3 기본값 활용

```swift
lastName.compare(firstName)
lastName.compare(firstName, options: .caseInsensitive)
```

### 5.4 첫 번째 이후 인수는 모두 레이블

```swift
object.addObserver(self, forKeyPath: "value")
```

---

## 6. 문서화

```swift
/// Returns the sum of two integers.
/// - Parameters:
///   - lhs: The first integer to add.
///   - rhs: The second integer to add.
/// - Returns: The sum of `lhs` and `rhs`.
func add(_ lhs: Int, _ rhs: Int) -> Int { lhs + rhs }
```

* 요약은 한 문장
* 함수/메서드: Returns/Inserts/Removes
* Subscript: Accesses
* Initializer: Creates
* 프로퍼티: 간단 설명 + 타입
* 복잡도 명시: O(1) 아닌 경우

---

## 7. 코드 스타일

* 들여쓰기: 4 spaces
* 연산자 앞뒤 공백
* 콜론 뒤 공백
* 긴 매개변수 줄바꿈
* 체이닝 줄바꿈
* 타입 추론 활용
* 트레일링 클로저 활용
* guard로 조기 반환
* 옵셔널 안전 처리

---

## 8. 체크리스트

* 타입/변수/함수 네이밍 체크
* Mutating/Nonmutating 일관성
* Boolean 프로퍼티 단언문
* 매개변수 레이블 확인
* 문서화 존재 여부
* 줄바꿈/공백 규칙 확인

---

## 9. 실전 예제

### 9.1 네트워크 매니저

```swift
final class NetworkManager {
    var isConnected: Bool { true }
    
    func fetchData(from url: URL, completion: @escaping (Result<Data, Error>) -> Void) { }
    
    func send(_ data: Data, to url: URL, method: HTTPMethod = .post) async throws -> Response { }
    
    func cancelAllRequests() { }
}
```

### 9.2 컬렉션 확장

```swift
extension Array {
    func filtered(where isIncluded: (Element) -> Bool) -> [Element] { filter(isIncluded) }
    mutating func removeAll(where shouldRemove: (Element) -> Bool) { self = filter { !shouldRemove($0) } }
    func allSatisfy(_ predicate: (Element) -> Bool) -> Bool { !contains { !predicate($0) } }
}
```

### 9.3 사용자 인증

```swift
@MainActor
final class AuthenticationService {
    private(set) var currentUser: User?
    var isSignedIn: Bool { currentUser != nil }
    func signIn(email: String, password: String) async throws { }
    func signInWithStoredCredentials() async throws { }
    func signOut() { currentUser = nil }
    func resetPassword(for email: String) async throws { }
}
```

---

## 10. 참고 자료

* [Swift API Design Guidelines](https://www.swift.org/documentation/api-design-guidelines/)
* [Swift Programming Language](https://docs.swift.org/swift-book/)
* [Swift Style Guide by Google](https://google.github.io/swift/)
* [Swift Style Guide by Ray Wenderlich](https://github.com/raywenderlich/swift-style-guide)
