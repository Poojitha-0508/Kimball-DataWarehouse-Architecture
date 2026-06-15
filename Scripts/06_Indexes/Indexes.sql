USE AppAnalytics;

-- Fast lookups on the fact table by each dimension
CREATE INDEX IX_fact_date   ON dw.fact_app_events(date_key);
CREATE INDEX IX_fact_app    ON dw.fact_app_events(app_key);
CREATE INDEX IX_fact_user   ON dw.fact_app_events(user_key);
CREATE INDEX IX_fact_device ON dw.fact_app_events(device_key);
CREATE INDEX IX_fact_region ON dw.fact_app_events(region_key);

-- Fast filter on event type (very common in analytics)
CREATE INDEX IX_fact_event_type ON dw.fact_app_events(event_type);