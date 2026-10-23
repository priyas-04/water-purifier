import React, { useState, useEffect } from 'react';
import { 
  Bot, 
  Instagram, 
  MessageSquare, 
  Sparkles, 
  CheckCircle, 
  Clock, 
  ExternalLink,
  Play,
  RotateCw
} from 'lucide-react';
import { mockService } from '../services/mockData';
import { AutomationLog, Product } from '../types';

export const AutomationLogs: React.FC = () => {
  const [logs, setLogs] = useState<AutomationLog[]>([]);
  const [isRunningAutomation, setIsRunningAutomation] = useState(false);
  const [selectedLog, setSelectedLog] = useState<AutomationLog | null>(null);

  const loadLogs = () => {
    setLogs(mockService.getAutomationLogs());
  };

  useEffect(() => {
    loadLogs();
  }, []);

  const handleTriggerTestRun = async () => {
    setIsRunningAutomation(true);
    await new Promise(r => setTimeout(r, 1500));

    // Pick next product from catalog
    const products = mockService.getProducts();
    const randomProduct = products[Math.floor(Math.random() * products.length)];

    const captions = [
      `Transform your drinking water with ${randomProduct.name}! 💧 Crystal clarity and certified purity for healthy living. #AquaPure #PureWater #${randomProduct.category} #HealthLiving`,
      `Did you know? ${randomProduct.verifiedBenefit || 'Pure alkaline water boosts daily immunity and metabolism.'} Experience it with AquaPure today! #AquaPure #WaterPurifier #CleanWater #AlkalineLife`,
      `Commercial strength performance in your kitchen: ${randomProduct.name}. Book free installation today! #AquaPure #${randomProduct.category} #KitchenAppliances`,
    ];

    const randomCaption = captions[Math.floor(Math.random() * captions.length)];
    const newLogId = `LOG-${Date.now()}`;
    const mockPostId = `180${Math.floor(10000000000000 + Math.random() * 90000000000000)}`;

    const newLog: AutomationLog = {
      id: newLogId,
      productId: randomProduct.id,
      productName: randomProduct.name,
      timestamp: new Date().toISOString(),
      channel: 'instagram',
      caption: randomCaption,
      imageUrl: randomProduct.imageUrl,
      postIdentifier: mockPostId,
      status: 'success',
    };

    mockService.getAutomationLogs().unshift(newLog);
    loadLogs();
    setIsRunningAutomation(false);
  };

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
        <div>
          <h2 className="text-xl font-bold font-['Outfit'] text-slate-800">AI Marketing Automation Hub</h2>
          <p className="text-slate-500 text-xs mt-0.5">
            Autonomous daily social media publishing powered by n8n, LLM copywriting, and Instagram Graph API
          </p>
        </div>
        <button
          onClick={handleTriggerTestRun}
          disabled={isRunningAutomation}
          className="inline-flex items-center gap-2 px-4 py-2 bg-gradient-to-r from-purple-600 to-pink-600 hover:from-purple-500 hover:to-pink-500 text-white font-semibold text-xs rounded-xl shadow-sm transition-all disabled:opacity-50"
        >
          {isRunningAutomation ? (
            <>
              <RotateCw className="w-4 h-4 animate-spin" />
              Executing n8n AI Pipeline...
            </>
          ) : (
            <>
              <Play className="w-4 h-4 fill-current" />
              Trigger Live Test Post
            </>
          )}
        </button>
      </div>

      {/* Workflow Architecture Card */}
      <div className="bg-gradient-to-r from-slate-900 to-indigo-950 rounded-2xl p-6 text-white border border-slate-800">
        <div className="flex items-center gap-2 text-xs font-bold text-sky-400 uppercase tracking-wider mb-2">
          <Bot className="w-4 h-4" />
          Autonomous Pipeline Architecture
        </div>
        <div className="grid grid-cols-1 md:grid-cols-4 gap-4 mt-4">
          <div className="p-3 bg-white/5 rounded-xl border border-white/10">
            <div className="text-[10px] text-slate-400 font-bold uppercase">1. Schedule Trigger</div>
            <div className="font-bold text-sm mt-1">Daily 09:00 AM IST</div>
            <div className="text-[11px] text-slate-400 mt-1">Asia/Kolkata timezone cron</div>
          </div>
          <div className="p-3 bg-white/5 rounded-xl border border-white/10">
            <div className="text-[10px] text-slate-400 font-bold uppercase">2. Product Rotation</div>
            <div className="font-bold text-sm mt-1">Deterministic Selector</div>
            <div className="text-[11px] text-slate-400 mt-1">Rotates across 60 catalogue items</div>
          </div>
          <div className="p-3 bg-white/5 rounded-xl border border-white/10">
            <div className="text-[10px] text-slate-400 font-bold uppercase">3. AI Generation</div>
            <div className="font-bold text-sm mt-1">LLM + Cloudinary CDN</div>
            <div className="text-[11px] text-slate-400 mt-1">Generates punchy caption & tags</div>
          </div>
          <div className="p-3 bg-white/5 rounded-xl border border-white/10">
            <div className="text-[10px] text-slate-400 font-bold uppercase">4. Social Publishing</div>
            <div className="font-bold text-sm mt-1">Instagram Graph API</div>
            <div className="text-[11px] text-slate-400 mt-1">Official Meta Business endpoint</div>
          </div>
        </div>
      </div>

      {/* Logs Feed */}
      <div className="space-y-4">
        <div className="flex items-center justify-between">
          <h3 className="font-bold text-base text-slate-800 font-['Outfit']">Publishing Execution History</h3>
          <span className="text-xs text-slate-500 font-medium">{logs.length} logs recorded</span>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
          {logs.map((log) => (
            <div 
              key={log.id}
              className="bg-white rounded-2xl border border-slate-200/80 shadow-sm overflow-hidden flex flex-col justify-between"
            >
              <div>
                {/* Image */}
                <div className="aspect-square w-full relative bg-slate-100 overflow-hidden">
                  <img 
                    src={log.imageUrl} 
                    alt={log.productName} 
                    className="w-full h-full object-cover"
                  />
                  <div className="absolute top-3 left-3 px-2 py-1 bg-black/70 backdrop-blur-sm text-white rounded-lg text-[10px] font-semibold flex items-center gap-1.5">
                    <Instagram className="w-3 h-3 text-pink-400" />
                    <span>Instagram Feed</span>
                  </div>
                  <div className="absolute top-3 right-3 px-2 py-0.5 bg-emerald-500 text-white rounded-full text-[10px] font-bold">
                    PUBLISHED
                  </div>
                </div>

                {/* Content */}
                <div className="p-4">
                  <div className="text-[11px] text-slate-400 font-mono">{log.productId}</div>
                  <h4 className="font-bold text-sm text-slate-800 mt-0.5 line-clamp-1">{log.productName}</h4>
                  <p className="mt-2 text-xs text-slate-600 line-clamp-3 leading-relaxed">
                    {log.caption}
                  </p>
                </div>
              </div>

              {/* Footer */}
              <div className="px-4 py-3 bg-slate-50 border-t border-slate-100 flex items-center justify-between text-[11px]">
                <div className="text-slate-400">
                  {new Date(log.timestamp).toLocaleDateString('en-IN', {
                    day: 'numeric',
                    month: 'short',
                    hour: '2-digit',
                    minute: '2-digit',
                  })}
                </div>
                <div className="font-mono text-slate-500 text-[10px]">
                  ID: {log.postIdentifier.substring(0, 10)}...
                </div>
              </div>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
};
