-- =============================================================
-- SRT Smart Station — Supabase Setup
-- Run this in Supabase Dashboard → SQL Editor
-- =============================================================

-- 1. Advertisements Table
CREATE TABLE IF NOT EXISTS advertisements (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  type TEXT DEFAULT 'banner',           -- banner, popup, video, interstitial
  status TEXT DEFAULT 'scheduled',      -- scheduled, active, paused
  start_date DATE,
  end_date DATE,
  image_url TEXT,
  impressions INTEGER DEFAULT 0,
  clicks INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. Popups Table
CREATE TABLE IF NOT EXISTS popups (
  id SERIAL PRIMARY KEY,
  title TEXT NOT NULL,
  trigger_type TEXT DEFAULT 'on-wake',  -- on-wake, delay-15, manual, scheduled
  active BOOLEAN DEFAULT true,
  texts JSONB DEFAULT '{}',             -- {th: "...", en: "...", cn: "...", kr: "..."}
  langs JSONB DEFAULT '{}',             -- {th: true, en: true, cn: false, kr: false}
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 3. Banners Table (Promotional / Carousel)
CREATE TABLE IF NOT EXISTS banners (
  id SERIAL PRIMARY KEY,
  tag JSONB DEFAULT '{}',               -- {th: "...", en: "..."}
  title JSONB DEFAULT '{}',             -- {th: "...", en: "...", cn: "...", kr: "..."}
  description JSONB DEFAULT '{}',       -- {th: "...", en: "...", cn: "...", kr: "..."}
  image_url TEXT,
  start_date DATE,
  end_date DATE,
  highlights JSONB DEFAULT '[]',
  price TEXT,
  location JSONB DEFAULT '{}',          -- {th: "...", en: "..."}
  category TEXT DEFAULT 'event',        -- event, promo, tourism
  priority INTEGER DEFAULT 0,
  active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- =============================================================
-- Row Level Security (RLS)
-- =============================================================

-- Enable RLS
ALTER TABLE advertisements ENABLE ROW LEVEL SECURITY;
ALTER TABLE popups ENABLE ROW LEVEL SECURITY;
ALTER TABLE banners ENABLE ROW LEVEL SECURITY;

-- Public read (anon key can read)
CREATE POLICY "Public read ads" ON advertisements FOR SELECT USING (true);
CREATE POLICY "Public read popups" ON popups FOR SELECT USING (true);
CREATE POLICY "Public read banners" ON banners FOR SELECT USING (true);

-- Public write (anon key — acceptable for internal kiosk system)
CREATE POLICY "Public insert ads" ON advertisements FOR INSERT WITH CHECK (true);
CREATE POLICY "Public update ads" ON advertisements FOR UPDATE USING (true);
CREATE POLICY "Public delete ads" ON advertisements FOR DELETE USING (true);

CREATE POLICY "Public insert popups" ON popups FOR INSERT WITH CHECK (true);
CREATE POLICY "Public update popups" ON popups FOR UPDATE USING (true);
CREATE POLICY "Public delete popups" ON popups FOR DELETE USING (true);

CREATE POLICY "Public insert banners" ON banners FOR INSERT WITH CHECK (true);
CREATE POLICY "Public update banners" ON banners FOR UPDATE USING (true);
CREATE POLICY "Public delete banners" ON banners FOR DELETE USING (true);

-- =============================================================
-- Sample Data (Optional — delete if you don't need it)
-- =============================================================

INSERT INTO advertisements (name, type, status, start_date, end_date, image_url, impressions, clicks)
VALUES
  ('Summer Travel Promo', 'banner', 'active', '2026-02-01', '2026-03-31', 'https://images.unsplash.com/photo-1506744038136-46273834b3fb?w=800', 1250, 89),
  ('SRT Mobile App Launch', 'interstitial', 'scheduled', '2026-03-01', '2026-04-30', 'https://images.unsplash.com/photo-1556388158-158ea5ccacbd?w=800', 0, 0);

INSERT INTO popups (title, trigger_type, active, texts, langs)
VALUES
  ('Welcome Message', 'on-wake', true,
   '{"th": "ยินดีต้อนรับสู่สถานีกลางกรุงเทพอภิวัฒน์", "en": "Welcome to Krung Thep Aphiwat Central Terminal", "cn": "欢迎来到曼谷中央车站", "kr": "방콕 중앙역에 오신 것을 환영합니다"}',
   '{"th": true, "en": true, "cn": true, "kr": true}');

INSERT INTO banners (tag, title, description, image_url, start_date, end_date, highlights, price, location, category, priority, active)
VALUES
  ('{"th": "โปรโมชั่น", "en": "Promotion"}',
   '{"th": "ตั๋วรถไฟราคาพิเศษ", "en": "Special Train Ticket", "cn": "特价火车票", "kr": "특가 기차표"}',
   '{"th": "เดินทางสะดวก ราคาสบายกระเป๋า", "en": "Travel comfortably at great prices", "cn": "舒适出行，优惠价格", "kr": "편안한 여행, 특별한 가격"}',
   'https://images.unsplash.com/photo-1474487548417-781cb71495f3?w=800',
   '2026-02-01', '2026-04-30',
   '["50% off", "Weekend only"]',
   '199 THB',
   '{"th": "ทุกเส้นทาง", "en": "All routes"}',
   'promo', 10, true);
