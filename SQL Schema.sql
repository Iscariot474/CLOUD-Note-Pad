-- Users table
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    sso_provider VARCHAR(50),   -- e.g. 'google', 'github', 'microsoft'
    sso_id VARCHAR(255),        -- SSO unique identifier
    avatar_url TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Roles table
CREATE TABLE roles (
    id SERIAL PRIMARY KEY,
    name VARCHAR(20) UNIQUE NOT NULL -- 'admin', 'editor', 'viewer'
);

-- User Roles (many-to-many)
CREATE TABLE user_roles (
    user_id INT REFERENCES users(id),
    role_id INT REFERENCES roles(id),
    PRIMARY KEY (user_id, role_id)
);

-- Folders table
CREATE TABLE folders (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    parent_id INT REFERENCES folders(id) ON DELETE SET NULL, -- For nested folders
    owner_id INT REFERENCES users(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Notes table
CREATE TABLE notes (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    content TEXT,
    owner_id INT REFERENCES users(id),
    folder_id INT REFERENCES folders(id),
    is_public BOOLEAN DEFAULT false,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tags table
CREATE TABLE tags (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL
);

-- Note-Tags (many-to-many)
CREATE TABLE note_tags (
    note_id INT REFERENCES notes(id) ON DELETE CASCADE,
    tag_id INT REFERENCES tags(id) ON DELETE CASCADE,
    PRIMARY KEY (note_id, tag_id)
);

-- Comments table
CREATE TABLE comments (
    id SERIAL PRIMARY KEY,
    note_id INT REFERENCES notes(id) ON DELETE CASCADE,
    user_id INT REFERENCES users(id),
    content TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- GitHub Links table
CREATE TABLE github_links (
    id SERIAL PRIMARY KEY,
    note_id INT REFERENCES notes(id) ON DELETE CASCADE,
    github_url TEXT NOT NULL,
    github_type VARCHAR(20), -- 'issue', 'pr', 'repo'
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
