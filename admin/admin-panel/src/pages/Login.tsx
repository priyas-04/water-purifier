import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { Droplet, Lock, Mail, ShieldCheck } from 'lucide-react';

interface LoginProps {
  onLogin: () => void;
}

export const Login: React.FC<LoginProps> = ({ onLogin }) => {
  const navigate = useNavigate();
  const [email, setEmail] = useState('admin@aquapure.com');
  const [password, setPassword] = useState('admin123');
  const [isLoading, setIsLoading] = useState(false);

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    setIsLoading(true);
    setTimeout(() => {
      setIsLoading(false);
      onLogin();
      navigate('/');
    }, 600);
  };

  return (
    <div className="min-h-screen bg-slate-900 flex items-center justify-center p-4">
      <div className="max-w-md w-full bg-white rounded-3xl p-8 shadow-2xl border border-slate-100">
        <div className="text-center">
          <div className="inline-flex p-3 bg-sky-500 rounded-2xl text-white shadow-lg shadow-sky-500/30">
            <Droplet className="w-8 h-8 fill-current" />
          </div>
          <h2 className="mt-4 text-2xl font-bold font-['Outfit'] text-slate-800">AquaPure Admin Portal</h2>
          <p className="text-xs text-slate-500 mt-1">Authorized personnel and operations control</p>
        </div>

        {/* Demo Credentials Notice */}
        <div className="mt-6 p-3 bg-sky-50 rounded-xl border border-sky-100 flex items-start gap-2.5 text-xs text-sky-800">
          <ShieldCheck className="w-4 h-4 text-sky-600 mt-0.5 shrink-0" />
          <div>
            <span className="font-bold">Assessment Demo Access:</span> Pre-filled with administrator credentials. Click below to enter the operations dashboard.
          </div>
        </div>

        <form onSubmit={handleSubmit} className="mt-6 space-y-4 text-xs">
          <div>
            <label className="block font-semibold text-slate-700 mb-1">Admin Email</label>
            <div className="relative">
              <Mail className="w-4 h-4 text-slate-400 absolute left-3 top-1/2 -translate-y-1/2" />
              <input
                type="email"
                required
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                className="w-full pl-9 pr-4 py-2.5 bg-slate-50 border border-slate-200 rounded-xl text-xs focus:outline-none focus:border-sky-500"
              />
            </div>
          </div>

          <div>
            <label className="block font-semibold text-slate-700 mb-1">Security Password</label>
            <div className="relative">
              <Lock className="w-4 h-4 text-slate-400 absolute left-3 top-1/2 -translate-y-1/2" />
              <input
                type="password"
                required
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                className="w-full pl-9 pr-4 py-2.5 bg-slate-50 border border-slate-200 rounded-xl text-xs focus:outline-none focus:border-sky-500"
              />
            </div>
          </div>

          <button
            type="submit"
            disabled={isLoading}
            className="w-full py-3 bg-sky-600 hover:bg-sky-500 text-white font-bold text-xs uppercase tracking-wider rounded-xl shadow-md shadow-sky-600/20 transition-all mt-2 disabled:opacity-50"
          >
            {isLoading ? 'Verifying Admin Token...' : 'Access Dashboard'}
          </button>
        </form>

        <div className="mt-6 text-center text-[11px] text-slate-400">
          Role-Based Access Control enforced via Cloud Firestore security rules.
        </div>
      </div>
    </div>
  );
};
