-- Theme preview sample code
-- This file is used to preview colorschemes with realistic code examples

return [[
// ========================================
//  JavaScript/TypeScript Example
// ========================================
import React, { useState, useEffect } from 'react';

interface User {
  id: number;
  name: string;
  email?: string;
}

const fetchUsers = async (): Promise<User[]> => {
  const response = await fetch('/api/users');
  return response.json();
};

function UserComponent({ user }: { user: User }) {
  const [count, setCount] = useState(0);
  const message = `Hello, ${user.name}!`;

  useEffect(() => {
    console.log('Component mounted');
    return () => console.log('Cleanup');
  }, []);

  return (
    <div className="user-card">
      <h1>{message}</h1>
      <button onClick={() => setCount(count + 1)}>
        Count: {count}
      </button>
    </div>
  );
}

// ========================================
//  Python Example
// ========================================
from typing import List, Optional
import asyncio

class DataProcessor:
    """Process and analyze data efficiently."""

    def __init__(self, data: List[int]):
        self.data = data
        self._cache = {}

    @property
    def size(self) -> int:
        return len(self.data)

    async def process(self) -> Optional[float]:
        """Calculate average with error handling."""
        try:
            total = sum(self.data)
            return total / self.size if self.size > 0 else None
        except Exception as e:
            print(f"Error: {e}")
            return None

# Usage
processor = DataProcessor([1, 2, 3, 4, 5])
result = asyncio.run(processor.process())

// ========================================
//  Lua Example
// ========================================
local M = {}

---@class Config
---@field enabled boolean
---@field timeout number
local default_config = {
  enabled = true,
  timeout = 5000,
}

---Setup the plugin with user config
---@param opts Config|nil
function M.setup(opts)
  opts = opts or {}
  local config = vim.tbl_deep_extend("force", default_config, opts)

  vim.api.nvim_create_user_command("TestCommand", function()
    vim.notify("Hello from Lua!", vim.log.levels.INFO)
  end, { desc = "Test command" })
end

return M

// ========================================
//  HTML/CSS Example
// ========================================
<!DOCTYPE html>
<html lang="en">
<head>
  <style>
    .container {
      display: flex;
      justify-content: center;
      background-color: #1e1e1e;
    }

    .button:hover {
      transform: scale(1.1);
      transition: all 0.3s ease;
    }
  </style>
</head>
<body>
  <div class="container">
    <button class="button" onclick="handleClick()">
      Click Me
    </button>
  </div>
</body>
</html>

// ========================================
//  Highlights Test
// ========================================
// Keywords: const let var function class if else return
// Strings: "double quotes" 'single quotes' `template ${string}`
// Numbers: 42 3.14 0xFF 1e10
// Operators: + - * / = == === != !== && || ! ??
// Comments: // inline comment /* block comment */
// TODO: This is a todo comment
// FIXME: This needs fixing
// NOTE: Important note here
]]
