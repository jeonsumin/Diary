# Diary

## 일기장 앱
 
### 기능 상세 
- 일기장 탭을 누르면 일기 리스트를 표시할 수 있습니다. 
- 즐겨찾기 탭을 누르면 즐겨찾기한 일기 리스트를 표시할 수 있습니다. 
- 일기를 등록, 수정, 삭제, 즐겨찾기 할 수 있습니다. 

### 활용 기술 
- UITabBarController 
- UICollectionView
- NotificationCenter

### DEMO


## 배운 내용 
#### UITabBarController 
> 다중 선택 인터페이스를 관리하는 컨테이너 뷰 컨으롤러로, 선택에 따라 어떤 지식 뷰 컨트롤러를 보여줄 것인지가 결정

<img width="549" alt="스크린샷 2022-01-03 오전 10 30 19" src="https://user-images.githubusercontent.com/51107183/147894516-c8dbb29d-aa5e-47d9-a8f5-a7dcb987d25b.png">


#### UICollectionView
> 데이터 항목의 정렬된 컬렉션을 관리하고 커스텀한 레이아웃을 사용해 표시하는 객체 

- 구성요소
	- **Cell**
<br> 컬렉션 뷰의 콘텐츠를 표시 
	-  **Supplementary View**
<br> 섹션에 대한 정보를 표시
	- **Decoration View**
<br> 컬렉션뷰에 대한 배경을 꾸밀 때 사용 
	
#### CollectionViewFlowLayout
<img width="1070" alt="스크린샷 2022-01-03 오전 10 36 46" src="https://user-images.githubusercontent.com/51107183/147894652-c6272c74-8c03-4d7f-81c9-25fbecadb06b.png">

<img width="997" alt="스크린샷 2022-01-03 오전 10 37 12" src="https://user-images.githubusercontent.com/51107183/147894691-e0af5e48-c76b-4c2e-9003-7b4669a908ec.png">

<img width="1215" alt="스크린샷 2022-01-03 오전 10 38 50" src="https://user-images.githubusercontent.com/51107183/147894706-b33ff54f-7e81-4916-9675-02bb9b879574.png">

- Flow 레이아웃 객체를 작성하고 컬렉션 뷰에 이를 할당한다. 
- 셀의 width, height를 정한다.
- 필요한 경우 셀들 간의 좌우 최소 간격, 위아래 최소 간격을 설정한다. 
- 섹션에 Header와 Footer가 있다면 이것들의 크기를 지정한다. 
- 레이아웃의 스크롤 방향을 설정한다. 

<img width="1399" alt="스크린샷 2022-01-03 오전 10 41 13" src="https://user-images.githubusercontent.com/51107183/147894742-81deab4e-7412-4b3d-bdee-c70599c6d481.png">

<img width="751" alt="스크린샷 2022-01-03 오전 10 41 38" src="https://user-images.githubusercontent.com/51107183/147894752-4244f99c-6a0c-48ef-8018-4d99de2ba106.png">

#### UICollectionViewDataSource
> 컬렉션 뷰로 보여지는 콘텐츠들을 관리하는 객체 

<img width="1343" alt="스크린샷 2022-01-03 오전 10 42 55" src="https://user-images.githubusercontent.com/51107183/147894780-614f0e59-955f-49a8-8027-732b525ca508.png">

#### UICollectionViewDelegate 
> 콘텐츠의 표현, 사용자와의 상호작용과 관련된 것들을 관리하는 객체 

- **CollectionVIew와 관련된 핵심 객체들의 관계**

<img width="851" alt="스크린샷 2022-01-03 오전 10 43 57" src="https://user-images.githubusercontent.com/51107183/147894825-ed2e4a51-c499-40d4-be74-bce29453bd72.png">

