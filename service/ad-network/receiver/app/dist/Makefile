.PHONY: all
all: ad-network-receiver

.PHONY: ad-network-receiver
ad-network-receiver: /etc/systemd/ad-network-receiver.service
	systemctl start $@
	systemctl enable $@

/etc/systemd/ad-network-receiver.service: config/systemd/ad-network-receiver.service
	cp $< $@
