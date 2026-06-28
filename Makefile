IMAGE_NAME    = my-ocr-bot
DOCKERFILE    = ./docker/Dockerfile
DOCKERHUB_IMG = sanjarcode/my-ocr-bot

# Extract IP from the first connected ADB device (works for both USB and TCP/IP)
DEVICE_IP   = $(shell adb devices | grep -v "List of devices" | awk '/device$$/{print $$1}' | head -1 | cut -d: -f1)

.DEFAULT_GOAL := help

.PHONY: help setup push run

help:
	@echo ""
	@echo "PitchPerfect — usage flow:"
	@echo ""
	@echo "  1. Pair your phone (one-time, before setup):"
	@echo "       plug in via USB, then:"
	@echo "         adb tcpip 5555"
	@echo "         adb connect <phone-ip>:5555"
	@echo "         adb devices   # verify it shows up"
	@echo "       then unplug USB — it stays connected over WiFi"
	@echo ""
	@echo "  2. Build the Docker image (once):"
	@echo "       make setup"
	@echo ""
	@echo "  3. Run the bot (detects phone IP automatically each time):"
	@echo "       make run"
	@echo ""
	@echo "  Targets:"
	@echo "    setup   Build the Docker image locally"
	@echo "    push    Push the image to Docker Hub (run setup first)"
	@echo "    run     Detect phone IP, write to .env, start the bot"
	@echo "    help    Show this message"
	@echo ""

setup:
	@echo ">>> Building Docker image..."
	docker build -t $(IMAGE_NAME) -f $(DOCKERFILE) .
	@echo ">>> Setup complete. Run 'make push' to publish, or 'make run' to start the bot."

push:
	@echo ">>> Tagging and pushing to Docker Hub..."
	docker tag $(IMAGE_NAME) $(DOCKERHUB_IMG):latest
	docker push $(DOCKERHUB_IMG):latest
	@echo ">>> Pushed: https://hub.docker.com/r/$(DOCKERHUB_IMG)"

run:
	@echo ">>> Starting ADB server on host..."
	adb start-server
	@echo ">>> Detecting device IP via adb..."
	@[ -n "$(DEVICE_IP)" ] || (echo "ERROR: No ADB device found. Connect your phone first." && exit 1)
	@echo "    Found: $(DEVICE_IP)"
	@if grep -q "^DEVICE_IP=" .env; then \
		sed -i '' 's|^DEVICE_IP=.*|DEVICE_IP="$(DEVICE_IP)"|' .env; \
	else \
		echo 'DEVICE_IP="$(DEVICE_IP)"' >> .env; \
	fi
	@if docker ps --filter "name=^$(IMAGE_NAME)$$" --format '{{.Names}}' | grep -q .; then \
		echo "Bot is already running. Stop it first with: docker stop $(IMAGE_NAME)"; exit 1; \
	fi
	@echo ">>> Running bot..."
	docker run --rm \
		--name $(IMAGE_NAME) \
		--add-host=host.docker.internal:host-gateway \
		--env-file .env \
		$(IMAGE_NAME)
