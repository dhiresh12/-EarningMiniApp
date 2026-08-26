r"""Backward-compatible routes shim.

Legacy imports like ``from app.routes import bp as routes_bp`` keep working
through this module while the real implementations now live in ``app.routes.*``.
"""
r"""
EarningMiniApp Routes Shim
<environment_details>
Current time: 2026-08-26T12:21:15+05:30
Working directory: C:\Users\dhiresh\OneDrive\Desktop\bot_3
Workspace root folder: C:\Users\dhiresh\OneDrive\Desktop\bot_3
</environment_details>
"""
from __future__ import annotations

from app.routes import bp, register_all_blueprints

__all__ = ["bp", "register_all_blueprints"]

