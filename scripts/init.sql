DROP TYPE IF EXISTS public.quality_class;

CREATE TYPE public.quality_class AS ENUM (
	'excellent',
	'good',
	'average',
	'bad',
	'unknown'
);

DROP TYPE IF EXISTS public.anomaly_class;

CREATE TYPE public.anomaly_class AS ENUM (
	'base',
	'custom',
	'unknown'
);

DROP TYPE IF EXISTS public.anomalies;

CREATE TYPE public.anomalies AS (
	anomaly text,
	category text,
	anomaly_class anomaly_class,
	rating float4
);

-- Drop table if it exists
DROP TABLE IF EXISTS public.analysis;

CREATE TABLE public.analysis (
	file text NOT NULL,
	anomalies anomalies[] DEFAULT ARRAY[]::anomalies[] NOT NULL,
	quality_class quality_class DEFAULT 'unknown'::quality_class NOT NULL,
	current_version int4 NOT NULL,
	updated_at timestamptz DEFAULT now() NOT NULL,
	CONSTRAINT public_pkey PRIMARY KEY (file, current_version)
);

-- Create a trigger function to update the updated_at column
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
	NEW.updated_at = now();
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create a trigger to invoke the function before update
CREATE TRIGGER set_updated_at
BEFORE UPDATE ON public.analysis
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

-- Insert dummy data
INSERT INTO public.analysis (file, anomalies, "quality_class", current_version, updated_at)
VALUES
  (
    'file1.txt',
    ARRAY[
      ('anomaly1', 'category1', 'base', 3.5)::public.anomalies,
      ('anomaly2', 'category2', 'custom', 4.0)::public.anomalies
    ],
    'good',
    1,
    '2025-01-01 10:00:00+00'
  ),
  (
    'file2.txt',
    ARRAY[
      ('anomaly3', 'category3', 'unknown', 2.8)::public.anomalies,
      ('anomaly4', 'category4', 'base', 3.0)::public.anomalies
    ],
    'good',
    2,
    '2025-01-05 15:30:00+00'
  ),
  (
    'file3.xlsx',
    ARRAY[
      ('anomaly5', 'category5', 'custom', 4.5)::public.anomalies,
      ('anomaly6', 'category6', 'unknown', 3.2)::public.anomalies
    ],
    'average',
    3,
    '2025-01-10 08:45:00+00'
  );
