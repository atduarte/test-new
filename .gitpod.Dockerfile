FROM archlinux:base-devel

USER root

ENV ARQUIVOLTA_KEY 8C23AC40F9AC3CD756ADBB240D3678F5DF8F474D

RUN pacman-key --recv-keys ${ARQUIVOLTA_KEY} && \
	pacman-key --lsign-key ${ARQUIVOLTA_KEY} && \
	pacman -Syu --noconfirm

RUN echo '[arquivolta]' >> /etc/pacman.conf && echo 'Server = https://x86-64.repo.arquivolta.dev' >> /etc/pacman.conf

RUN pacman --noconfirm -Sy \
	docker docker-compose screen htop vim git zsh sudo go \
	arquivolta-new-user-template nodejs npm python-poetry

RUN echo '%wheel ALL=(ALL:ALL) ALL' > /etc/sudoers.d/00-enable-wheel && \
	echo '' >> /etc/sudoers.d/00-enable-wheel \
	chmod 644 /etc/sudoers.d/00-enable-wheel

RUN useradd -m -G wheel -s /bin/zsh 'ani'

USER ani
ENV USER ani

RUN cd /tmp && \
	git clone https://aur.archlinux.org/yay.git && cd yay \
	&& makepkg && pacman --noconfirm -U $(ls *.zst)