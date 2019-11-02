# 失敗したJobを消す
Delayed::Worker.destroy_failed_jobs = true

# リトライしない
Delayed::Worker.max_attempts = 0
# Delayed::Worker.max_attempts = 5

Delayed::Worker.sleep_delay = 120
Delayed::Worker.max_run_time = 5.minutes
Delayed::Worker.read_ahead = 5
Delayed::Worker.delay_jobs = !Rails.env.test?

# TODO: エラーがあった場合に通知する
