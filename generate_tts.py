#!/usr/bin/env python3
"""Generate TTS audio files using edge-tts (Microsoft Azure Neural voices)"""
import asyncio
import edge_tts
import os

OUTDIR = os.path.join(os.path.dirname(__file__), "audio")
os.makedirs(OUTDIR, exist_ok=True)

# Voice mapping (male voices)
VOICES = {
    "th": "th-TH-NiwatNeural",
    "en": "en-US-GuyNeural",
    "cn": "zh-CN-YunxiNeural",
    "kr": "ko-KR-InJoonNeural",
}

# All fixed text from the kiosk app
TEXTS = {
    # Greetings
    "greeting": {
        "th": "สวัสดีครับ ยินดีต้อนรับสู่สถานีกลางกรุงเทพอภิวัฒน์ มีอะไรให้ช่วยไหมครับ?",
        "en": "Welcome to Krung Thep Aphiwat Central Terminal. How can I help you?",
        "cn": "欢迎来到曼谷中央车站。有什么可以帮您？",
        "kr": "아피왓 중앙역에 오신 것을 환영합니다. 무엇을 도와드릴까요?",
    },
    # FAQ answers
    "toilet": {
        "th": "ห้องน้ำอยู่ทางขวามือ เดินตรงไป 50 เมตรครับ",
        "en": "Restrooms are 50m to your right.",
        "cn": "洗手间在右边50米处。",
        "kr": "화장실은 오른쪽으로 50m 거리에 있습니다.",
    },
    "ticket": {
        "th": "เคาน์เตอร์ขายตั๋วอยู่ที่ประตู 4 ครับ",
        "en": "Ticket counters are at Gate 4.",
        "cn": "售票处在4号门。",
        "kr": "매표소는 4번 게이트에 있습니다.",
    },
    "food": {
        "th": "ศูนย์อาหารอยู่ชั้น 3 ขึ้นบันไดเลื่อนได้เลยครับ",
        "en": "Food Court is on the 3rd floor.",
        "cn": "美食广场在3楼。",
        "kr": "푸드 코트는 3층에 있습니다.",
    },
    "wifi": {
        "th": "ใช้เครือข่าย SRT-FreeWiFi ลงทะเบียนด้วยพาสปอร์ตครับ",
        "en": "Connect to SRT-FreeWiFi.",
        "cn": "连接 SRT-FreeWiFi。",
        "kr": "SRT-FreeWiFi에 연결하세요.",
    },
    "taxi": {
        "th": "จุดรอแท็กซี่อยู่ชั้น G ทางออก 7 ครับ",
        "en": "Taxi stand is at G Floor, Exit 7.",
        "cn": "出租车站位于G层7号出口。",
        "kr": "택시 승강장은 G층 7번 출구입니다.",
    },
    "lost": {
        "th": "ติดต่อจุดบริการ Lost and Found ที่ชั้น 1 ประตู 2 ครับ",
        "en": "Visit Lost and Found at 1st floor, Gate 2.",
        "cn": "请到一楼2号门的失物招领处。",
        "kr": "1층 2번 게이트 분실물 센터를 방문하세요.",
    },
    # Dynamic fallback
    "fallback": {
        "th": "ขอโทษครับ ลองถามเรื่อง ห้องน้ำ หรือ รถไฟ ดูไหมครับ?",
        "en": "Sorry, try asking about Restroom or Train.",
    },
    "train": {
        "th": "รถไฟขบวนถัดไปจะออกในอีก 15 นาทีครับ ชานชาลาที่ 1",
        "en": "Next train departs in 15 minutes, Platform 1.",
    },
}

async def generate_all():
    count = 0
    for key, langs in TEXTS.items():
        for lang, text in langs.items():
            voice = VOICES.get(lang, VOICES["en"])
            filename = f"{key}_{lang}.mp3"
            filepath = os.path.join(OUTDIR, filename)

            print(f"  Generating {filename} ({voice})...")
            comm = edge_tts.Communicate(text, voice, rate="-5%")
            await comm.save(filepath)

            size = os.path.getsize(filepath)
            count += 1
            print(f"    -> {size:,} bytes")

    print(f"\nDone! Generated {count} audio files in {OUTDIR}")

if __name__ == "__main__":
    asyncio.run(generate_all())
