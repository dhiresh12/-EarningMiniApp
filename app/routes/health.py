"""Flask blueprint: health check."""
from __future__ import annotations

from flask import Blueprint, current_app, jsonify

bp = Blueprint("health", __name__)

@bp.get("/api/health")
def health_check():
    return jsonify({"status": "ok", "app": "EarningMiniApp"}), 200
