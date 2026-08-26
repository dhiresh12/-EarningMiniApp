"""Flask blueprint: auth endpoints."""
from __future__ import annotations

from flask import Blueprint, current_app, jsonify, request

from app.routes._helpers import (
    _check_rate_limit,
    _safe_int,
    _get_user_id_from_request,
    _require_auth_post,
    _require_auth_get,
)

bp = Blueprint("auth", __name__)



@bp.post("/api/auth/register")
def register() -> tuple[dict, int]:
    if not _check_rate_limit("auth:register", limit=5, window=300):
        return jsonify({"error": "Too many attempts. Try again later."}), 429
    current_engine = current_app.config["engine"]
    payload = request.get_json(silent=True) or {}
    phone = payload.get("phone", "")
    password = payload.get("password", "")
    name = payload.get("name", "")
    if not phone or not password:
        return jsonify({"error": "Phone and password required"}), 400
    if len(password) < 6:
        return jsonify({"error": "Password must be at least 6 characters"}), 400
    success, message, profile = current_engine.register_with_phone(phone, password, name)
    if not success:
        return jsonify({"error": message}), 400
    token = current_engine.create_session(profile.user_id)
    return jsonify({"token": token, "user_id": profile.user_id, "name": profile.name}), 200


@bp.post("/api/auth/login")
def login() -> tuple[dict, int]:
    if not _check_rate_limit("auth:login", limit=10, window=300):
        return jsonify({"error": "Too many attempts. Try again later."}), 429
    current_engine = current_app.config["engine"]
    payload = request.get_json(silent=True) or {}
    phone = payload.get("phone", "")
    password = payload.get("password", "")
    if not phone or not password:
        return jsonify({"error": "Phone and password required"}), 400
    success, message, profile = current_engine.login_with_phone(phone, password)
    if not success:
        return jsonify({"error": message}), 401
    token = current_engine.create_session(profile.user_id)
    return jsonify({"token": token, "user_id": profile.user_id, "name": profile.name}), 200


@bp.post("/api/auth/otp/send")
def send_otp() -> tuple[dict, int]:
    if not _check_rate_limit("auth:otp_send", limit=3, window=300):
        return jsonify({"error": "Too many OTP requests. Try again later."}), 429
    current_engine = current_app.config["engine"]
    payload = request.get_json(silent=True) or {}
    phone = payload.get("phone", "")
    if not phone:
        return jsonify({"error": "Phone number required"}), 400
    success, message = current_engine.generate_and_send_otp(phone)
    if not success:
        return jsonify({"error": message}), 400
    return jsonify({"success": True, "message": message}), 200


@bp.post("/api/auth/otp/verify")
def verify_otp() -> tuple[dict, int]:
    if not _check_rate_limit("auth:otp_verify", limit=5, window=300):
        return jsonify({"error": "Too many attempts. Try again later."}), 429
    current_engine = current_app.config["engine"]
    payload = request.get_json(silent=True) or {}
    phone = payload.get("phone", "")
    otp = payload.get("otp", "")
    if not phone or not otp:
        return jsonify({"error": "Phone and OTP required"}), 400
    success, message, profile = current_engine.verify_otp(phone, otp)
    if not success:
        return jsonify({"error": message}), 400
    token = current_engine.create_session(profile.user_id)
    return jsonify({"token": token, "user_id": profile.user_id, "name": profile.name}), 200
