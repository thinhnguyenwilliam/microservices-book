import http from 'k6/http';
import { check, sleep } from 'k6';

// Cấu hình Load Test
export const options = {
  stages: [
    { duration: '10s', target: 20 }, // Ramp-up lên 20 Virtual Users trong 10s
    { duration: '30s', target: 20 }, // Giữ nguyên 20 VUs trong 30s
    { duration: '10s', target: 50 }, // Ramp-up lên 50 VUs trong 10s (Stress)
    { duration: '20s', target: 50 }, // Giữ 50 VUs trong 20s
    { duration: '10s', target: 0 },  // Ramp-down về 0 trong 10s
  ],
};

export default function () {
  const url = 'http://localhost:8080/identity/users';
  
  // Tạo username ngẫu nhiên để tránh lỗi Duplicate Key trong DB
  const randomId = Math.floor(Math.random() * 1000000000);
  const payload = JSON.stringify({
    username: `thinhnguyen_k6_${randomId}`,
    password: 'secretpassword',
    firstName: 'Thinh',
    lastName: 'Nguyen',
    dob: '1995-01-01'
  });

  const params = {
    headers: {
      'Content-Type': 'application/json',
    },
  };

  // Gửi POST request
  const res = http.post(url, payload, params);

  // Kiểm tra response (201 Created)
  check(res, {
    'is status 201': (r) => r.status === 201,
    'is status 500': (r) => r.status === 500, // Để track xem có bị lỗi DB không
  });

  // Tạm nghỉ 100ms giữa các request của mỗi VU
  sleep(0.1);
}
