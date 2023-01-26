# front_end

- Web: run project on a specific port locally: It's important to have --web-rendered canvaskit because of lottie.
flutter run -d web-server --web-renderer canvaskit --web-hostname 192.168.1.66 --web-port 5001

- Retrofit: compile de retrofit api so that we can have the libraries for the request. We just need to create\
the entites and some key functions we need. and the rest will be done and generated automatically.
flutter pub run build_runner build


