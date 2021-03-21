# StampChat Chat Server
StampChat is a mobile chat app. This repo contains one of the services backing that app. This service handles user messaging, message history, and chat groups. This service includes the Websocket service needed for real-time chatting.

# Project Overview

This service is written in Elixir and uses the [Phoenix](https://www.phoenixframework.org/) framework.

This service is part of a larger project. For a complete project overview see the:
* [StampChat infrastructure repo](https://github.com/OsamaElHariri/StampChat_Kubernetes)
* [StampChat mobile app repo](https://github.com/OsamaElHariri/StampChat_App)

# Setting up localhost Testing

To setup for localhost testing:

1. Get the dependacies
```sh
mix deps.get
```

2. Make sure the database is running and that the DB connection string `db_url` in `config.yaml` is correct
3. Run the databse migrations
```sh
mix ecto.migrate
```
4. (Optional) Make sure that the [notification server](https://github.com/OsamaElHariri/StampChat_NotificationsServer) is running on port 3001
1. Run this server
```sh
mix phx.server
```

