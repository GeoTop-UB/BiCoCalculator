.PHONY: frontend backend

frontend:
	cd frontend && nix develop --command make

backend:
	cd backend && nix develop --command make

bundle:
	nix bundle --bundler github:DavHau/nix-portable ./backend
