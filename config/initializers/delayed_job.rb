Delayed::Worker.destroy_failed_jobs = false
Delayed::Worker.sleep_delay = 120
Delayed::Worker.max_attempts = 5
Delayed::Worker.max_run_time = 5.minutes
Delayed::Worker.read_ahead = 5
Delayed::Worker.delay_jobs = !Rails.env.test?
