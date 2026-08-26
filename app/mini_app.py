from __future__ import annotations

import json
import os

from flask import Flask, render_template

from app.ads import AdsManager
from app.config import load_config
from app.core import BotEngine
from app.routes import register_all_blueprints


def create_app(engine: BotEngine | None = None) -> Flask:
    app = Flask(__name__, template_folder="templates")
    app.config["SECRET_KEY"] = load_config().secret_key

    current_engine = engine or BotEngine(storage_path="bot_data.db")
    ads_manager = AdsManager(provider=load_config().ads_provider)

    app.config["engine"] = current_engine
    app.config["ads_manager"] = ads_manager
    register_all_blueprints(app)

    @app.get("/")
    def index() -> str:
        config = load_config()
        return render_template(
            "mini_app.html",
            app_name=config.app_name,
            app_version=config.app_version,
            translations_json=json.dumps(current_engine.support.translations),
            lang_config_json=json.dumps(current_engine.support.lang_config),
            support_links_json=json.dumps(current_engine.support.get_support_links()),
            provider=ads_manager.get_config()["provider"],
        )

    return app


app = create_app()

if __name__ == "__main__":
    config = load_config()
    app.run(host=config.host, port=config.port, debug=(config.environment == "development"))
