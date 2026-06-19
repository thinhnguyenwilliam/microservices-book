# =====================================================
# Book-Ecommerce - Root Makefile
# =====================================================
# Dùng `make help` để xem danh sách lệnh

.PHONY: help \
        fix-permissions fix-ownership \
        identity-run identity-build identity-test identity-clean \
        profile-run  profile-build  profile-test  profile-clean  \
        docker-up docker-down docker-logs docker-ps \
        kill-port clean-all

# ---------- Màu sắc terminal ----------
GREEN  := \033[0;32m
YELLOW := \033[1;33m
CYAN   := \033[0;36m
RESET  := \033[0m

# =====================================================
# HELP
# =====================================================
help:
	@echo ""
	@echo "$(CYAN)╔══════════════════════════════════════════════════╗$(RESET)"
	@echo "$(CYAN)║         Book-Ecommerce - Makefile Commands       ║$(RESET)"
	@echo "$(CYAN)╚══════════════════════════════════════════════════╝$(RESET)"
	@echo ""
	@echo "$(YELLOW)⚙  Setup:$(RESET)"
	@echo "  make fix-permissions     Fix quyền execute cho tất cả mvnw"
	@echo "  make fix-ownership       Fix owner target/ (khi đã lỡ chạy sudo)"
	@echo "  make kill-port           Kill process đang chiếm port 8080"
	@echo ""
	@echo "$(YELLOW)🔐 Identity Service:$(RESET)"
	@echo "  make identity-run        Chạy identity-service (port 8080)"
	@echo "  make identity-build      Build identity-service"
	@echo "  make identity-test       Test identity-service"
	@echo "  make identity-clean      Clean target/ của identity-service"
	@echo ""
	@echo "$(YELLOW)👤 Profile Service:$(RESET)"
	@echo "  make profile-run         Chạy profile-service"
	@echo "  make profile-build       Build profile-service"
	@echo "  make profile-test        Test profile-service"
	@echo "  make profile-clean       Clean target/ của profile-service"
	@echo ""
	@echo "$(YELLOW)🐳 Docker:$(RESET)"
	@echo "  make docker-up           Khởi động tất cả containers"
	@echo "  make docker-down         Tắt tất cả containers"
	@echo "  make docker-logs         Xem logs containers"
	@echo "  make docker-ps           Xem trạng thái containers"
	@echo ""
	@echo "$(YELLOW)🚀 Tổng hợp:$(RESET)"
	@echo "  make clean-all           Clean tất cả services"
	@echo ""

# =====================================================
# SETUP
# =====================================================
fix-permissions:
	@echo "$(GREEN)▶ Cấp quyền execute cho mvnw...$(RESET)"
	chmod +x identity-service/mvnw
	chmod +x profile-service/mvnw
	@echo "$(GREEN)✔ Xong! Giờ có thể chạy ./mvnw mà không cần sudo.$(RESET)"

# Fix owner target/ về user hiện tại (khi đã lỡ chạy với sudo)
fix-ownership:
	@echo "$(YELLOW)▶ Fix ownership target/ về user: $(USER)...$(RESET)"
	sudo chown -R $(USER):$(USER) identity-service/target 2>/dev/null || true
	sudo chown -R $(USER):$(USER) profile-service/target 2>/dev/null || true
	@echo "$(GREEN)✔ Xong!$(RESET)"

# Kill process đang chiếm port 8080
kill-port:
	@PID=$$(lsof -ti :8080) ; \
	if [ -n "$$PID" ]; then \
		echo "$(YELLOW)▶ Kill process $$PID đang chiếm port 8080...$(RESET)"; \
		kill -9 $$PID && echo "$(GREEN)✔ Đã kill!$(RESET)"; \
	else \
		echo "$(GREEN)✔ Port 8080 đang trống.$(RESET)"; \
	fi

# =====================================================
# IDENTITY SERVICE
# =====================================================
identity-run: _check-identity-permission
	@echo "$(GREEN)▶ Chạy identity-service...$(RESET)"
	cd identity-service && ./mvnw spring-boot:run

identity-build: _check-identity-permission
	@echo "$(GREEN)▶ Build identity-service...$(RESET)"
	cd identity-service && ./mvnw clean package -DskipTests

identity-test: _check-identity-permission
	@echo "$(GREEN)▶ Test identity-service...$(RESET)"
	cd identity-service && ./mvnw test

identity-clean:
	@echo "$(GREEN)▶ Clean identity-service...$(RESET)"
	cd identity-service && ./mvnw clean

_check-identity-permission:
	@if [ ! -x "identity-service/mvnw" ]; then \
		echo "$(YELLOW)⚠ mvnw chưa có quyền execute → đang tự fix...$(RESET)"; \
		chmod +x identity-service/mvnw; \
	fi

# =====================================================
# PROFILE SERVICE
# =====================================================
profile-run: _check-profile-permission
	@echo "$(GREEN)▶ Chạy profile-service...$(RESET)"
	cd profile-service && ./mvnw spring-boot:run

profile-build: _check-profile-permission
	@echo "$(GREEN)▶ Build profile-service...$(RESET)"
	cd profile-service && ./mvnw clean package -DskipTests

profile-test: _check-profile-permission
	@echo "$(GREEN)▶ Test profile-service...$(RESET)"
	cd profile-service && ./mvnw test

profile-clean:
	@echo "$(GREEN)▶ Clean profile-service...$(RESET)"
	cd profile-service && ./mvnw clean

_check-profile-permission:
	@if [ ! -x "profile-service/mvnw" ]; then \
		echo "$(YELLOW)⚠ mvnw chưa có quyền execute → đang tự fix...$(RESET)"; \
		chmod +x profile-service/mvnw; \
	fi

# =====================================================
# DOCKER
# =====================================================
docker-up:
	@echo "$(GREEN)▶ Khởi động Docker containers...$(RESET)"
	sudo docker compose up -d

docker-down:
	@echo "$(GREEN)▶ Tắt Docker containers...$(RESET)"
	sudo docker compose down

docker-logs:
	sudo docker compose logs -f

docker-ps:
	sudo docker compose ps

# =====================================================
# TỔNG HỢP
# =====================================================
clean-all: identity-clean profile-clean
	@echo "$(GREEN)✔ Đã clean tất cả services.$(RESET)"
