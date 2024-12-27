import datetime
from uuid import uuid4, UUID
from sqlmodel import SQLModel, Field

class Chore(SQLModel, table=True):
    uuid: UUID = Field(default_factory=uuid4, primary_key=True)
    name: str
    created_at: datetime.datetime = Field(default_factory=datetime.datetime.utcnow)
