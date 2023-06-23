# stock_app
<img src="https://user-images.githubusercontent.com/74657556/220307342-1aeebc42-1f24-4c70-8a0d-6ea85c6888d5.jpeg" width="250" height="500">

회원 기능(로그인, 로그아웃, 회원가입)이 있고 회원으로 로그인하여 자산 포트폴리오를 생성할 수 뿐만 아니라 포트폴리오 목록을 조회할 수 있고 수정 및 삭제가능한 앱 애플리케이션입니다. 
<br/>
● Android : [app-release.apk.zip](https://github.com/seongchangkim/stock_app/files/10792092/app-release.apk.zip)<br/>
● IOS : [Runner.zip](https://github.com/seongchangkim/stock_app/files/10792079/Runner.zip)<br/>
● 제작기간 : 2023.1.5~2023.02.17(1인 프로젝트)

### 개발 환경
#### 1). Skill Stack
> 1. Dart 2.18.6
> 2. Flutter 3.3.10

#### 2). IDE
> 1. Visual Studio Code

## 주요 기능 및 페이지
### 1. 스플래시 화면
<img src="https://user-images.githubusercontent.com/74657556/220309573-f25baef5-b624-4b6d-be7f-c3d76ff1da43.jpeg" width="250" height="500">
<br/>
스플래시 화면에서 이 앱 안에 사용자 정보를 들어있는 쿠키를 통해 가져오는 사용자 정보를 통해 유효하고 존재하는지 검사하고 그 사용자 정보가 유효하고 존재하면 홈 화면으로 이동하고 그렇지 않으면 로그인 페이지로 이동 

### 2. 회원가입
https://user-images.githubusercontent.com/74657556/220310054-8c7d65e6-b5d5-4905-b309-c42a90796879.mp4

<br/>
- 로그인 페이지에서 회원가입 부분을 누르면 회원가입 페이지가 뜨는데 회원정보를 입력하여 회원가입 버튼을 클릭하면 회원가입 API를 POST방식으로 호출하여 입력한 회원정보를 들고 request해서 작동함. 회원가입이 성공하면 해당 회원이 생성이 되면서 회원가입 완료 알림창이 뜨고 확인 버튼을 누르면 로그인 페이지로 이동.(유효성 검사 기능도 있음.)


### 3. 로그인
https://user-images.githubusercontent.com/74657556/220310852-30a94987-7a47-4959-92e8-e32eb8633679.mp4

<br/>
- 로그인 페이지에서 이메일과 비밀번호를 입력하여 로그인 API를 POST방식으로 호출하여 입력한 이메일과 비밀번호를 들고 request해서 작동함. 그 다음에 DB에서 이메일으로 일치한 데이터를 조회하여 비밀번호를 암호화하여 DB에서 암호화된 비밀번호가 있는지 조회함. DB에서 이메일과 비밀번호가 둘 다 일치한 DB가 있으면 로그인 성공되어 홈 화면으로 이동함. 그렇지 않으면 상황별로 알림창을 뜨도록 설정함.(유효성 검사 기능도 있음.)

### 4. 로그아웃
<img src="https://user-images.githubusercontent.com/74657556/220315562-49fd4889-1b48-4529-b417-0902c87d560f.gif" width="250" height="500">

<br/>
- 더보기 페이지에 들어가서 로그아웃 부분에 클릭하면 로그아웃 API를 POST방식으로 호출하여 사용자 id를 들고 request해서 작동함. 그 다음에 해당 회원에 대한 앱 쿠키가 지워지고 DB안에 해당 회원 id를 찾아서 token를 빈 값으로 수정함. 마지막으로 user 저장소를 빈 객체로 초기화시키고 로그인 페이지로 이동함.


### 5. 프로필 상세보기, 프로필 정보 수정 및 회원 탈퇴
<img src="https://user-images.githubusercontent.com/74657556/220316730-e103610f-068c-4b1d-8a40-3d9f01c9614c.jpeg" width="250" height="500">
<p align="center">프로필 상세보기</p>


https://user-images.githubusercontent.com/74657556/220317161-ee49de4f-f5a6-4675-ab85-858a0fc64e39.mp4
<p align="center">프로필 정보 수정</p>

<img src="https://user-images.githubusercontent.com/74657556/220350951-b6ea53ec-9429-42b7-a5b5-33f46befc233.gif" width="250" height="500">
<p align="center">회원 탈퇴</p>


<br/>
1). 프로필 상세보기 : 더보기 페이지에 들어가서 프로필 정보를 클릭하면 상태관리으로 저장된 사용자 정보를 들고 프로필 상세보기 페이지에 출력함. 
2). 프로필 정보 수정 : 프로필 상세보기 페이지에서 수정하고자 이름과 전화번호를 수정하여 프로필 수정 버튼을 클릭하면 프로필 수정 API를 호출하여 수정하고자 이름과 전화번호를 들고 request해서 작동함. 그리고 DB에서 해당 사용자를 조회해서 해당 사용자와 일치하는 데이터에 이름과 전화번호를 수정하고 updatedAt 컬럼을 해당 API를 호출했던 시점으로 수정됨. 그 다음에 프로필 정보 수정이 성공하면 프로필 정보 수정 알림창이 뜸. 그리고 프로필 정보 수정 알림창에 확인 버튼을 누르면 그 부분이 취소가 됨.(유효성 검사 기능도 있음.)
3). 회원 탈퇴 : 프로필 상세보기 페이지에서 회원 탈퇴를 누르면 회원 탈퇴 API를 호출하여 해당 사용자 id를 들고 request해서 작동함. 그리고 DB에서 해당 사용자 id로 조회하여 해당 사용자와 일치하면 deletedAt를 해당 API를 호출했던 시점으로 저장되고 회원 탈퇴 처리가 성공하면 회원 탈퇴 알림창을 뜸. 회원 탈퇴 알림창에서 확인 버튼을 클릭하면 로그인 페이지로 이동됨.

### 6. 홈 화면(생성한 자산 포트폴리오 목록 조회)
<img src="https://user-images.githubusercontent.com/74657556/220388064-be1cb275-2b9d-482d-8061-c7caa18329a4.jpeg" width="250" height="500">
<p align="center">기존에 생성했던 자산 포트폴리오 목록이 있을 때</p>
<img src="https://user-images.githubusercontent.com/74657556/220388116-ce588afc-247e-4642-845a-5458798be6a9.jpeg" width="250" height="500">
<p align="center">기존에 생성했던 자산 포트폴리오 목록이 없을 때</p>

<br/>
스플래시를 통해 홈 화면으로 이동하기 전에 자산 포트폴리오 목록 API를 호출하여 해당 회원 id을 들고 request해서 작동함. 그리고 DB에서 해당 회원 id에 자산 포트폴리오에 대한 데이터들을 조회해서 response로 자산 포트폴리오 클라이언트에 뿌려서 자산 포트폴리오 목록을 출력함.

### 7. 자산 포트폴리오 생성

https://user-images.githubusercontent.com/74657556/220392727-432628d5-2d44-453a-89b0-0582f47f5806.mp4

홈 화면에서 + 버튼을 누르면 자산 포트폴리오 생성 페이지를 들어갈 수 있는데 그 페이지에 + 버튼을 누르면 생성하고자 포트폴리오에 추가할 자산 및 비율을 추가로 입력할 수 있음. 생성 버튼을 클릭하고 자산 포트폴리오 생성 API를 호출하여 입력한 값을 request로 보냈는데 DB에 해당 포트폴리오를 생성되고 해당 자산 포트폴리오 생성이 성공하면 이전 페이지로 이동하면서 새로고침하면 포트폴리오 생성 알림창을 띄움 .(유효성 검사 기능도 있음.)

### 8. 자산 포트폴리오 상세보기 및 삭제
<img src="https://user-images.githubusercontent.com/74657556/220394078-674523ed-e7c9-40f3-af77-a5114bb52d8c.jpeg" width="250" height="500">
<p align="center">자산 포트폴리오 상세보기</p>

![asset_portfolio_delete](https://user-images.githubusercontent.com/74657556/220394372-7dc8eaf9-a15e-497c-8010-96493883db3d.gif)
<p align="center">자산 포트폴리오 삭제</p>

1). 자산 포트폴리오 상세보기 : 홈 화면에서 해당 자산 포트폴리오를 클릭하면 해당 자산 포트폴리오 상세보기 페이지에 들어가게 전에 자산 포트폴리오 상세보기 API를 호출하여 해당 포트폴리오 Index값을 들고 request해서 작동함. 그리고 DB에 해당 portIndex를 활용하여 해당 포트폴리오 정보를 조회하여 Response Data를 보내어 그 페이지에 출력하게 됨.
2). 자산 포트폴리오 삭제 : 해당 자산 포트폴리오에 삭제 버튼을 클릭하면 해당 자산 포트폴리오 삭제 API를 호출하여 해당 포트폴리오 Index값을 들고 request해서 작동함. 그리고 DB에 해당 portIndex를 활용하여 그것에 대해 조회하고 해당 portIndex에 조회된 자산 포트폴리오 데이터에 deletedAt를 해당 API를 호출했던 시점으로 저장되고 자산 포트폴리오 삭제 처리가 성공하면 이전 페이지를 이동하면서 새로고침을 하면서 포트폴리오 삭제 알림창이 됨.

### 9. 자산 포트폴리오 수정

https://user-images.githubusercontent.com/74657556/220395912-8aefca90-d3b9-441f-b77c-7f41f0f67117.mp4

해당 자산 포트폴리오 상세보기 페이지에서 수정 버튼을 누르면 해당 자산 포트폴리오 수정 페이지가 출력되고 자산 포트폴리오 생성 페이지와 마찬가지로 그 페이지에 + 버튼을 누르면 수정하고자 포트폴리오에 추가할 자산 및 비율을 추가로 입력할 수 있음. 수정하고자 포트폴리오 정보를 입력하여 수정 버튼을 누르면 해당 포트폴리오 수정 API을 호출하여 수정하고자 포트폴리오 정보를 들고 request해서 작동함. 그리고 DB에서 해당 portIndex를 활용하여 그것에 대해서 조회하여 해당 portIndex에 조회된 자산 포트폴리오 데이터에 수정하고자 포트폴리오 정보로 수정되고 updatedAt가 해당 API를 호출했던 시점으로 수정됨. 그리고 포트폴리오 정보 수정이 성공하면 이전 페이지로 이동하면서 새로고침하면소 프로필 정보 수정 알림창이 뜸.

