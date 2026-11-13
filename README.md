# genAI URL 접속 테스트

`genai_urls.csv`에 들어 있는 생성형 AI 서비스 도메인을 순서대로 HTTPS로 접속하고, 목록이 끝나면 처음부터 다시 반복하는 스크립트입니다. 보안 웹 게이트웨이나 CASB에서 GenAI 앱 트래픽이 어떻게 분류·로그되는지 확인할 때 사용합니다.

## 구성

| 파일 | 역할 |
| --- | --- |
| `genai_test.sh` | CSV를 읽어 URL을 만들고, 무한 루프로 `curl` 접속을 수행 |
| `genai_urls.csv` | 앱 이름과 도메인 목록 (`app_name,domain`) |

CSV는 앱마다 도메인이 하나 이상입니다. 예를 들어 ChatGPT는 `chatgpt.com`, `chat.openai.com`처럼 관련 도메인이 여러 줄로 들어 있습니다. 스크립트는 `app_name`은 쓰지 않고 `domain`만 읽습니다.

## 동작

1. `genai_urls.csv`에서 헤더와 빈 줄을 건너뛰고 도메인만 모읍니다.
2. `http://` 또는 `https://`가 없으면 `https://`를 붙입니다.
3. 도메인마다 `[ACCESS] <url>`을 출력한 뒤 `curl -k`로 접속합니다.
4. 요청 사이에 1초를 기다립니다.
5. 목록 전체를 돌면 다시 처음부터 반복합니다.
6. `Ctrl+C`를 누르면 실행 중인 요청을 끊고 종료합니다.

`curl -k`는 TLS 인증서 검증을 끄고 접속합니다. 응답 본문은 터미널에 그대로 출력되고, 성공·실패는 따로 기록하지 않습니다.

## 실행

같은 디렉터리에서 실행합니다. `curl`이 필요합니다.

```bash
chmod +x genai_test.sh
./genai_test.sh
```

종료는 `Ctrl+C`입니다.

## CSV 형식

```csv
app_name,domain
ChatGPT,chatgpt.com
ChatGPT,chat.openai.com
```

도메인을 추가하거나 빼면 다음 실행부터 그 목록으로 접속합니다. 스크립트를 수정할 필요는 없습니다.
