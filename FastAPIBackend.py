from fastapi import FastAPI, Depends
from sqlalchemy.orm import Session
from .database import SessionLocal, engine, Base
from .models import User, Note

app = FastAPI()

# Create tables if they don't exist (for dev/test)
Base.metadata.create_all(bind=engine)

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@app.get("/users")
def read_users(db: Session = Depends(get_db)):
    return db.query(User).all()

@app.get("/notes")
def read_notes(db: Session = Depends(get_db)):
    return db.query(Note).all()
